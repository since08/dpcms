ActiveAdmin.register TemplateType do
  menu priority: 21, parent: '模版管理'
  filter :name
  permit_params :name
  actions :all, except: [:show]

  index do
    column :id
    column :name, sortable: false
    column :created_at, sortable: false

    actions name: '操作' do |type|
      item '新建回复内容', new_admin_reply_template_path + "?type_id=#{type.id}"
    end
  end
end
