ActiveAdmin.register AppVersion do
  menu priority: 50, parent: '发布管理'
  config.batch_actions = false
  config.filters = false

  permit_params :platform, :version, :force_upgrade, :title, :content
  form partial: 'form'

  index do
    column :platform
    column :version
    column :title
    column :force_upgrade
    actions
  end
end
