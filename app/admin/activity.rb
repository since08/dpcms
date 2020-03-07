# rubocop:disable Metrics/BlockLength
AC_PUSH_TYPES = Activity.push_types.keys
TRANS_AC_PUSH_TYPES = AC_PUSH_TYPES.collect { |d| [I18n.t("activity.#{d}"), d] }
ActiveAdmin.register Activity do
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'pushed_desc'

  permit_params :title, :pushed_img, :banner, :description, :activity_time,
                :link, :tag, :push_type, :start_push, :end_push,
                activity_en_attributes: [:title, :pushed_img, :banner, :description, :link, :tag]

  form partial: 'form'
  index do
    render 'index', context: self
  end

  show do
    render 'show', context: self
  end

  controller do
    before_action :strip_params, only: [:create, :update]

    def strip_params
      params[:activity][:description] = helpers.strip_tags(params[:activity][:description])
    end
  end

  member_action :push, method: :post do
    if Activity.find_by(pushed: true)
      flash[:error] = '推送失败，已有活动推送到首页'
      return redirect_back fallback_location: admin_activities_url
    end
    activity = Activity.find(params[:id])
    activity.push!
    redirect_back fallback_location: admin_activities_url, notice: '已成功推送到首页'
  end

  member_action :unpush, method: :post do
    activity = Activity.find(params[:id])
    activity.unpush!
    redirect_back fallback_location: admin_activities_url, notice: '已成功取消推送到首页'
  end
end
