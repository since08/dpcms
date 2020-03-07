ActiveAdmin.register RaceTag do
  menu priority: 23, label: '标签管理'
  config.filters = false
  config.batch_actions = false

  permit_params :name, race_tag_en_attributes: [:name]

  index do
    render 'index', context: self
  end

  form partial: 'form'
end
