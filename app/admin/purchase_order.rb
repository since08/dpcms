# rubocop:disable Metrics/BlockLength
# rubocop:disable Style/GlobalVars
ActiveAdmin.register PurchaseOrder do
  menu priority: 4, parent: '订单管理', label: '订单列表'
  permit_params :price, :email, :address, :consignee, :mobile, :status
  actions :all, except: [:new]
  ORDER_STATUS = PurchaseOrder.statuses.keys

  scope :all, default: 'true'
  scope :unpaid
  scope :paid
  scope :delivered
  scope :completed
  scope :canceled

  filter :user_user_uuid, as: :string
  filter :user_email_or_user_mobile, as: :string
  filter :order_number
  filter :invite_code
  filter :invite_person_name, as: :string
  filter :created_at
  filter :status, as: :select, multiple: true, collection: ORDER_STATUS.collect { |key| [I18n.t("order.#{key}"), key] }

  index do
    id_column
    column :ticket_name do |order|
      order.ticket.title
    end
    column :order_number
    column :user_id do |order|
      link_to order.user.nick_name, admin_user_url(order.user), target: '_blank'
    end
    column '真实姓名', :real_name do |order|
      order.user_extra&.real_name
    end
    column '实名状态', :user_status do |order|
      I18n.t("user_extra.#{order.user_extra&.status}") unless order.user_extra.nil?
    end
    column :original_price
    column :price
    column :final_price
    column :status, sortable: false do |order|
      I18n.t("order.#{order.status}")
    end
    column :created_at
    column :invite_code, sortable: false do |order|
      invite_code = order.invite_code
      invite_id = order.invite_person&.id
      link_to(invite_code, admin_invite_code_url(invite_id), target: '_blank') unless invite_id.nil?
    end
    column :invite_person_name, sortable: false do |order|
      order.invite_person&.name
    end
    actions name: '操作', defaults: false do |order|
      item '编辑', edit_admin_purchase_order_path(order), class: 'member_link'
      item '取消', change_status_admin_purchase_order_path(order, change_status: 'canceled'),
           data: { confirm: '确定取消吗？' }, method: :post
    end
  end

  action_item :add, only: :index do
    link_to '易联账单', admin_bills_path
  end

  action_item :add, only: :index do
    link_to '微信账单', admin_wx_bills_path
  end

  member_action :change_status, method: :post do
    change_status = params[:change_status]
    old_status = resource.status
    mobile = resource.mobile || resource.user.mobile
    template = if change_status.eql?('canceled')
                 $settings['cancel_order_template']
               elsif change_status.eql?('paid')
                 $settings['payment_template']
               elsif change_status.eql?('delivered')
                 $settings['shipping_template']
               end
    content = format(template, resource.order_number)
    return redirect_to(action: 'index') if old_status.eql? change_status
    if change_status.eql? 'canceled'
      Services::Orders::CancelOrderService.call(resource)
    else
      resource.update!(status: change_status)
    end
    # 记录操作日志
    Services::SysLog.call(current_admin_user, resource, 'change',
                          "订单状态被修改：#{I18n.t("order.#{old_status}")} -> #{I18n.t("order.#{change_status}")}")
    # 手机号不为空 并且 状态不相等的时候 才会去发短信
    unless old_status.eql?(change_status) || mobile.blank? || Rails.env.test?
      SmsJob.send_mobile(change_status, mobile, content)
    end
    if change_status.eql? 'canceled'
      redirect_to action: 'index'
    else
      render 'refresh_order'
    end
  end

  member_action :change_price, method: :post do
    return render 'common/params_format_error' if params[:order_price].blank?
    Services::SysLog.call(current_admin_user, resource, 'change_status',
                          "订单价格被修改：#{resource.price} -> #{params[:order_price]}")
    resource.update(price: params[:order_price].to_i)
    render 'common/update_success'
  end

  member_action :change_e_ticket_address, method: :post do
    email = params[:email].strip
    unless email.present? && UserValidator.email_valid?(email)
      return render 'common/email_format_error'
    end
    Services::SysLog.call(current_admin_user, resource, 'change_e_ticket_address', "收货邮箱被修改：#{resource.email} -> #{email}")
    resource.update!(email: email)
    render 'common/update_success'
  end

  member_action :change_entity_ticket_address, method: :post do
    consignee = params[:consignee].strip
    mobile = params[:mobile].strip
    address = params[:address].strip
    unless consignee.present? && mobile.present? && address.present?
      return render 'common/params_format_error'
    end
    return render 'common/mobile_format_error' unless UserValidator.mobile_valid?(mobile)
    mark = "收货人:#{resource.consignee}->#{consignee}, 手机:#{resource.mobile}->#{mobile}, 地址:#{resource.address}->#{address}"
    Services::SysLog.call(current_admin_user, resource, 'change_entity_ticket_address', mark)
    resource.update!(consignee: consignee, mobile: mobile, address: address)
    render 'common/update_success'
  end

  member_action :courier, method: :patch do
    courier_params = params[:purchase_order]
    if courier_params[:courier].blank? || courier_params[:tracking_no].blank?
      return render js: "alert('快递公司与快递单号不能为空');"
    end

    courier_params[:status] = 'delivered' if resource.paid?
    courier_params[:delivery_time] = Time.now
    resource.update! courier_params.as_json
    render 'refresh_order'
  end

  # 用户认证审核通过
  member_action :user_audit, method: :post do
    user_extra = resource.user_extra
    return render 'user_audit_failed' if user_extra.blank?
    Services::SysLog.call(current_admin_user, resource, 'user_audit',
                          "通过了用户#{resource.user_extra.real_name}的审核认证")
    user_extra.passed!
  end

  # 用户审核不通过
  member_action :user_audit_forbid, method: :post do
    memo = params[:memo] || user_extra.memo
    user_extra = resource.user_extra
    return render 'user_audit_failed' if user_extra.blank?
    Services::SysLog.call(current_admin_user, resource, 'user_audit',
                          "拒绝了用户#{resource.user_extra.real_name}的审核认证")
    user_extra.update!(memo: memo, status: 'failed')
  end

  form partial: 'edit_order'
end
