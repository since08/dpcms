# rubocop:disable Metrics/BlockLength
ActiveAdmin.register WeixinUser do
  menu priority: 1, parent: '用户管理'
  config.batch_actions = false
  config.clear_action_items!

  filter :user_id, as: :string
  filter :open_id
  filter :nick_name
  filter :province
  filter :city
  filter :created_at

  index do
    id_column
    column :open_id
    column '微信头像', :image do |info|
      link_to image_tag(info.head_img, height: '100px'), info.head_img, target: '_blank'
    end
    column :nick_name
    column :user_id do |wx_user|
      if wx_user.try(:user).present?
        link_to wx_user.user.nick_name, admin_user_url(wx_user.user), target: '_blank'
      end
    end
    column :sex do |info|
      info.sex.eql?(1) ? '男' : '女'
    end
    column :province
    column :city
    column :created_at
  end
end
