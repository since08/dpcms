# rubocop:disable Metrics/BlockLength
ActiveAdmin.register ProductOrder, namespace: :shop do
  config.breadcrumb = false
  PRODUCT_ORDER_STATUS = ProductOrder.statuses.keys
  menu priority: 3, parent: '订单管理'
  actions :all, except: [:new, :edit, :create, :destroy]

  scope :all, default: 'true'
  scope :unpaid
  scope :paid
  scope :delivered
  scope :completed
  scope :canceled

  filter :user_user_uuid, as: :string
  filter :user_email_or_user_mobile, as: :string
  filter :order_number
  filter :created_at

  member_action :cancel_order, method: [:get, :post] do
    return render :cancel unless request.post?
    reason = params[:cancel_reason]
    resource.cancel_order reason
    redirect_back fallback_location: shop_product_orders_url
  end

  member_action :shipping_detail, method: :get do
    return render :shipping_detail
  end

  index download_links: false do
    render 'index'
  end

  show do
    render 'show'
  end
end
