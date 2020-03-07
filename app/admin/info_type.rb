# rubocop:disable Metrics/BlockLength
ActiveAdmin.register InfoType do
  menu priority: 3, parent: '资讯管理', label: '资讯类别'
  permit_params :name, :level, :published, info_type_en_attributes: [:name]

  filter :name
  filter :published
  filter :created_at

  index title: '资讯类别' do
    column :name, sortable: false
    column :level, sortable: :level
    column :published, sortable: false
    column :topped do |type|
      info_item = type.infos.topped.first
      link_to info_item.title, admin_info_url(info_item), target: '_blank' if info_item
    end
    column :created_at, sortable: false

    actions name: '操作', class: 'info_actions', defaults: false do |type|
      if type.published
        item '取消发布', unpublish_admin_info_type_path(type),
             data: { confirm: '确定取消吗？' }, method: :post
      else
        item '发布', publish_admin_info_type_path(type),
             data: { confirm: '确定发布吗？' }, method: :post
      end
      item '编辑', edit_admin_info_type_path(type)
      item '删除', admin_info_type_path(type),
           data: { confirm: '确定取消吗？' }, method: :delete

      item '新建资讯', new_admin_info_path + "?type_id=#{type.id}"
    end
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_info_types_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    redirect_back fallback_location: admin_info_types_url, notice: '取消发布成功'
  end

  # 详情
  show do
    render 'show', context: self
  end

  form partial: 'form'
end
