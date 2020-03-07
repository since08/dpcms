# rubocop:disable Metrics/BlockLength
REPORT_TYPES = UserTopicReport.report_types.keys.collect { |d| [I18n.t("user_topic_report.#{d}"), d] }
ActiveAdmin.register UserTopicReport do
  menu priority: 10, parent: '社交管理', label: '举报管理'
  actions :all, except: [:show, :new, :create]

  filter :report_type, as: :select, collection: REPORT_TYPES
  filter :created_at

  index do
    id_column
    column :user_nickname, sortable: false do |report|
      link_to report.user.nick_name, admin_user_url(report.user), target: '_blank'
    end
    column :report_user_nickname, sortable: false do |report|
      link_to report.report_user.nick_name, admin_user_url(report.report_user), target: '_blank'
    end
    column :report_type, sortable: false do |report|
      I18n.t("user_topic_report.#{report.report_type}")
    end
    column :topic_title, &:topic_title
    column :report_times, &:report_times
    column :body, sortable: false
    column :description, sortable: false
    column :created_at
    actions name: '操作', defaults: false do |report|
      item '忽略', ignore_admin_user_topic_report_path(report), method: :post, data: { confirm: '确定吗？' }
    end
  end

  member_action :ignore, method: :post do
    resource.ignored!
    redirect_back fallback_location: admin_user_topic_reports_url, notice: '忽略成功'
  end

  controller do
    def scoped_collection
      super.where(ignored: false)
    end
  end
end
