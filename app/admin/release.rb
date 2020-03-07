ActiveAdmin.register Release do
  menu priority: 50, parent: '发布管理'
  config.batch_actions = false
  config.filters = false

  permit_params :keywords, :published
end
