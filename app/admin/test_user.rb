ActiveAdmin.register TestUser do
  config.batch_actions = false
  config.filters = false
  menu priority: 1, parent: '用户管理', label: '测试用户'

  index do
    column '用户昵称' do |test_user|
      test_user.user.nick_name
    end
    column '手机号' do |test_user|
      test_user.user.mobile
    end
    actions
  end

  controller do
    def new; end
  end

  member_action :build, method: :post do
    user = User.find(params[:id])
    TestUser.create(user: user)
    render js: 'window.location.reload();'
  end

  config.clear_action_items!
  action_item :add, only: :index do
    link_to '新增测试用户', new_admin_test_user_path, remote: true
  end
end
