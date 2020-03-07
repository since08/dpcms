# rubocop:disable Metrics/BlockLength
ActiveAdmin.register VideoType do
  menu false
  permit_params :name, :level, :published, video_type_en_attributes: [:name]

  filter :name
  filter :published
  filter :created_at

  index title: '视频类别' do
    column :name, sortable: false
    column :level, sortable: :level
    column :published, sortable: false
    column :topped do |type|
      video_item = type.videos.topped.first
      link_to video_item.name, admin_video_url(video_item), target: '_blank' if video_item
    end
    column :created_at, sortable: false

    actions name: '操作', class: 'video_actions', defaults: false do |type|
      if type.published
        item '取消发布', unpublish_admin_video_type_path(type),
             data: { confirm: '确定取消吗？' }, method: :post
      else
        item '发布', publish_admin_video_type_path(type),
             data: { confirm: '确定发布吗？' }, method: :post
      end
      item '编辑', edit_admin_video_type_path(type)
      item '删除', admin_video_type_path(type),
           data: { confirm: '确定取消吗？' }, method: :delete

      item '新建视频', new_admin_video_path + "?type_id=#{type.id}"
    end
  end

  form partial: 'form'

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_video_types_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    redirect_back fallback_location: admin_video_types_url, notice: '取消发布成功'
  end

  # 详情
  show do
    render 'show', context: self
  end
end
