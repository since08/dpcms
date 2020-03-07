# rubocop:disable Metrics/BlockLength
ActiveAdmin.register UserTopic do
  menu priority: 9, label: '社交管理', parent: '社交管理'

  actions :all, except: [:new, :create, :edit, :update, :destroy]

  includes :counter, :user, :topic_images

  BODY_TYPE = { 'short' => '说说', 'long' => '长帖' }.freeze

  filter :title
  filter :body
  filter :user_id
  filter :body_type, as: :select, collection: BODY_TYPE.invert
  filter :address_title
  filter :created_at, as: :date_range

  scope 'square', :all, default: true
  scope 'essence', :recommended

  index do
    render 'index', context: self
  end

  show do
    render 'show'
  end

  config.clear_action_items!

  action_item :recommend, only: :show do
    if resource.recommended
      link_to '取消精华', unrecommend_admin_user_topic_path(resource), method: :patch
    else
      link_to '加入精华', recommend_admin_user_topic_path(resource), method: :patch
    end
  end

  action_item :delete, only: :show do
    link_to '删除', delete_admin_user_topic_path(resource), remote: true
  end

  member_action :recommend, method: :patch do
    resource.update!(recommended: true)
    resource.user.counter.increment!(:great_topic_count)
    redirect_back fallback_location: admin_user_topics_url, notice: '加入精华成功'
  end

  member_action :unrecommend, method: :patch do
    resource.update!(recommended: false)
    resource.user.counter.decrement!(:great_topic_count)
    redirect_back fallback_location: admin_user_topics_url, notice: '取消精华成功'
  end

  member_action :delete, method: [:get, :post] do
    return(render 'delete') if request.get?
    resource.update!(deleted: true, deleted_at: Time.current, deleted_reason: params[:deleted_reason])
    redirect_back fallback_location: admin_user_topics_url, notice: '删除成功'
  end

  member_action :like_list, method: :get do
    @page_title = "点赞情况 (#{resource.counter.likes})"
    @topic_likes = resource.topic_likes.includes(:user).page(params[:page]).per(10)
    render 'like_list'
  end
end
