# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Video do
  menu priority: 3, parent: '资讯管理', label: '视频列表'
  belongs_to :video_group, optional: true
  permit_params :name, :video_link, :title_desc, :cover_link, :video_duration, :top, :published,
                :description, :video_type_id, :video_group_id, :race_tag_id,
                video_en_attributes: [:name, :title_desc, :description]
  scope :all
  scope('main_videos') do |scope|
    scope.where(is_main: true)
  end

  config.sort_order = ''

  filter :name
  filter :published
  filter :top
  filter :video_type_id, as: :select, collection: VideoType.video_type_array
  filter :race_tag_id, as: :select, collection: RaceTag.all

  index do
    render 'index', context: self
  end

  show do
    render 'show'
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_videos_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    resource.untop! if resource.top
    redirect_back fallback_location: admin_videos_url, notice: '取消发布成功'
  end

  member_action :change_group, method: [:get, :post] do
    @video = resource
    # 判断原来的组别下面是否有子视频，如果子视频数量超过2个，则不可更换组别
    old_group = @video.video_group
    return render :group_error if @video.is_main && old_group.videos.count > 2

    if request.post?
      group_id = params[:group_id]
      # 判断该组别是否存在
      return render :change_error unless VideoGroup.exists?(group_id)
      old_group.destroy if @video.is_main
      # 查询新组别最后一个position 并且更换所属的类别
      videos = VideoGroup.find(group_id).videos
      last_video = videos.position_asc.last
      type_id = videos.where(is_main: true).first.video_type_id
      new_position = last_video.position + 100000
      # 更新视频的组别
      @video.update(video_group_id: group_id, video_type_id: type_id, is_main: false, position: new_position)
      render :success
    else
      render :change_group
    end
  end

  member_action :top, method: :post do
    resource_type = resource.video_type || resource.build_video_type
    list = resource_type.videos.published.topped
    list.present? && list.map(&:untop!)
    resource.top!
    resource.publish! unless resource.published
    redirect_back fallback_location: admin_videos_url, notice: '置顶成功'
  end

  member_action :untop, method: :post do
    resource.untop!
    redirect_back fallback_location: admin_videos_url, notice: '取消置顶成功'
  end

  member_action :main_video, method: :post do
    # 取消该类别下所有视频的主视频
    resource&.video_group.videos.update(is_main: false)
    # 更新当前视频为主视频
    resource.update(is_main: true)
    redirect_to :back, notice: '设置成功'
  end

  member_action :reposition, method: :post do
    video = Video.find(params[:id])
    next_video = params[:next_id] && Video.find(params[:next_id].split('_').last)
    prev_video = params[:prev_id] && Video.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_video.position / 2
               elsif params[:next_id].blank?
                 prev_video.position + 100000
               else
                 (prev_video.position + next_video.position) / 2
               end
    video.update(position: position)
  end

  member_action :views, method: [:get, :post] do
    view_toggle = resource.topic_view_toggle
    unless request.post?
      @topic_view_toggle = view_toggle.present? ? view_toggle : TopicViewToggle.new
      return render :topic_view
    end
    on_off = params[:on_off].eql?('on') ? true : false
    hot = params[:type].eql?('hot') ? true : false
    # 判断之前是否有保存过
    create_params = { topic: resource,
                      toggle_status: on_off,
                      hot: hot,
                      begin_time: Time.now,
                      last_time: Time.now }
    view_toggle.present? ? view_toggle.update(create_params) : TopicViewToggle.create(create_params)
    redirect_back fallback_location: admin_infos_url, notice: '更改成功'
  end

  action_item :add, only: :index do
    link_to '视频类别', admin_video_types_path
  end

  form partial: 'edit_info'

  controller do
    def create
      group_id = update_params[:video_group_id]
      position = 100000
      # 真对组进行position排序
      if VideoGroup.exists?(group_id)
        last_group_video = Video.where(video_group_id: group_id).position_asc.last
        position = last_group_video&.position.to_i + 100000
      end
      @video = Video.new(update_params.merge(position: position))
      render :new unless @video.save
      url = VideoGroup.exists?(group_id) ? admin_video_group_videos_url(group_id) : admin_videos_url
      redirect_to url, notice: '添加成功'
    end

    def update
      unless resource.video_type_id.eql? update_params['video_type_id'].to_i
        # 说明更换了类别 那么不管 反正你要换类别，你先取消置顶再说
        resource.untop!
      end
      # 如果取消发布，也会先取消置顶
      resource.untop! if update_params['published'].to_i.zero?

      # 保存数据
      flash[:notice] = if resource.update!(update_params)
                         '视频更新成功'
                       else
                         '视频更新失败'
                       end
      redirect_to admin_videos_url
    end

    def destroy
      # 先找出要删除这个组别下的某个视频设为主视频，然后删除自己
      resource.video_group.videos.position_asc.each do |video|
        next if video.id.eql?(resource.id)
        video.update(is_main: true)
        break
      end
      super
    end

    def scoped_collection
      if request.env['REQUEST_URI'] =~ /video_groups/
        super.includes(:counter).position_asc
      else
        super.includes(:counter).order(created_at: :desc)
      end
    end

    private

    def update_params
      params.require(:video).permit(:name,
                                    :video_type_id,
                                    :video_group_id,
                                    :race_tag_id,
                                    :video_link,
                                    :cover_link,
                                    :title_desc,
                                    :video_duration,
                                    :is_show,
                                    :published,
                                    :top,
                                    :description,
                                    video_en_attributes: [:id, :name, :title_desc, :is_show, :description])
    end
  end
end
