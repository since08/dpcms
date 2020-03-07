# rubocop:disable Metrics/BlockLength
ActiveAdmin.register User do
  menu priority: 1, parent: '用户管理', label: 'app用户'

  permit_params :nick_name, :password, :password_confirmation, :email, :tag, :mobile, :mark, user_extra_attributes: [:id, :status]
  CERTIFY_STATUS = UserExtra.statuses.keys
  USER_STATUS = User.statuses.keys
  actions :all, except: [:new, :destroy]

  includes :counter, :user_extra

  scope :all
  scope('race_order_succeed') do |scope|
    scope.joins(:orders).where('purchase_orders.status NOT IN (?)', %w(unpaid canceled)).distinct
  end

  batch_action :'批量禁用', confirm: '确定操作吗?' do |ids|
    User.find(ids).each do |user|
      user.update(role: 'banned') unless user.role.eql?('banned')
    end
    Services::SysLog.call(current_admin_user, User.find(ids.first), 'batch_banned', "被禁用的id为->: #{ids.join(', ')}")
    redirect_back fallback_location: admin_users_url, notice: '批量禁用操作成功！'
  end

  batch_action :'批量启用', confirm: '确定操作吗?' do |ids|
    User.find(ids).each do |user|
      user.update(role: 'basic') if user.role.eql?('banned')
    end
    Services::SysLog.call(current_admin_user, User.find(ids.first), 'batch_unbanned', "被启用的id为->: #{ids.join(', ')}")
    redirect_back fallback_location: admin_users_url, notice: '批量启用操作成功！'
  end

  batch_action :destroy, false

  filter :id
  filter :user_name
  filter :nick_name
  filter :email
  filter :mobile
  filter :reg_date
  filter :last_visit
  filter :role, as: :select, collection: USER_STATUS.collect { |key| [I18n.t("user.#{key}"), key] }
  filter :user_extra_status, as: :select, collection: CERTIFY_STATUS.collect { |key| [I18n.t("user_extra.#{key}"), key] }

  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  form partial: 'form'

  sidebar :'数量统计', only: :index do
    success_count = UserExtra.where(status: 'passed').count
    bind_count = User.where.not(mobile: nil).count
    ul do
      li "会员数量：#{User.count}名"
      li "已实名数量：#{success_count}名"
      li "未实名数量：#{User.count - success_count}名"
      li "已绑手机用户：#{bind_count}名"
      li "未绑手机用户：#{User.count - bind_count}名"
    end
  end

  controller do
    before_action :init_params, only: [:update]

    def update
      Services::SysLog.call(current_admin_user, resource, '编辑用户', "被修改的用户id为->: #{resource.id}")
      update! do |format|
        format.html { redirect_to admin_users_url + "#user_#{resource.id}" }
      end
    end

    private

    def init_params
      params[:user][:mobile] = nil if params[:user][:mobile].blank?
      params[:user][:email] = nil if params[:user][:email].blank?
    end
  end

  # 禁用用户和启用用户
  member_action :user_banned, method: :post do
    resource.role.eql?('banned') ? resource.update!(role: 'basic') : resource.update!(role: 'banned')
    notice_str = resource.role.eql?('banned') ? '禁用' : '取消禁用'
    Services::SysLog.call(current_admin_user, resource, notice_str, "#{notice_str}用户: #{resource.id} - #{resource.nick_name}")
    render 'common/update_success'
  end

  # 查看用户资料
  member_action :user_profile, method: [:get] do
    @page_title = '用户信息'
    return render '_user_profile' unless request.xhr?
    render :user_profile
  end

  member_action :block_user, method: [:post] do
    resource.blocked!
    render 'common/update_success'
  end

  member_action :unblock_user, method: [:post] do
    resource.unblocked!
    render 'common/update_success'
  end

  member_action :silence_user, method: [:get, :post] do
    return render :silence unless request.post?
    resource.silenced!(params[:silence_reason], params[:silence_till])
    render 'common/update_success'
  end

  member_action :add_tag, method: [:get, :post] do
    return render :add_tag unless request.post?
    tag = UserTag.find(params[:tag_id])
    resource.user_tag_maps.create(user_tag: tag)
  end

  member_action :remove_tag, method: [:post] do
    tag = UserTag.find(params[:tag_id])
    resource.user_tag_maps.find_by(user_tag: tag).destroy
    render 'add_tag'
  end

  member_action :create_user_tag, method: [:post] do
    UserTag.create(name: params[:name])
    render 'add_tag'
  end

  member_action :dynamics, method: [:get] do
    @dynamics = resource.dynamics.normal_dynamics.order(created_at: :desc).page(params[:page]).per(8)
    @return_lists = {}
    @dynamics.collect do |dynamic|
      index = dynamic.created_at.strftime('%Y%m%d')
      @return_lists[index] = [] if @return_lists[index].blank?
      @return_lists[index].push(dynamic)
    end
    render 'show_dynamics'
  end

  action_item :user_extras, only: :index do
    link_to '实名列表', admin_user_extras_path
  end

  member_action :poker_coins, method: [:get, :post] do
    @dynamics = resource.poker_coins.page(params[:page]).per(10)
    @return_lists = {}
    @dynamics.collect do |dynamic|
      index = dynamic.created_at.strftime('%Y%m%d')
      @return_lists[index] = [] if @return_lists[index].blank?
      @return_lists[index].push(dynamic)
    end
  end

  member_action :followers, method: :get do
    @page_title = "粉丝列表(共计#{resource.counter.follower_count}个)"
    @followers = resource.followers.page(params[:page])
    render 'followers'
  end

  member_action :followings, method: :get do
    @page_title = "关注列表(共计#{resource.counter.following_count}个)"
    @followings = resource.followings.page(params[:page])
    render 'followings'
  end
end
