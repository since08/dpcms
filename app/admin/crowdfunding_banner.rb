# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Banner, as: 'crowdfunding_banner' do
  menu priority: 21, parent: '众筹管理', label: '众筹banner'
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_asc'
  scope :crowdfunding, default: true

  permit_params :image, :link, :source_id, :source_type

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    def create
      position = (Banner.last&.id.to_i + 1) * 100000
      @banner = Banner.new banner_params.merge(position: position, banner_type: 'crowdfunding')

      if @banner.save
        flash[:notice] = '新建banner成功'
        redirect_to admin_crowdfunding_banners_url
      else
        render :new
      end
    end

    def banner_params
      permitted_params[:banner]
    end
  end

  member_action :reposition, method: :post do
    banner = Banner.find(params[:id])
    next_banner = params[:next_id] && Banner.find(params[:next_id].split('_').last)
    prev_banner = params[:prev_id] && Banner.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_banner.position / 2
               elsif params[:next_id].blank?
                 prev_banner.position + 100000
               else
                 (prev_banner.position + next_banner.position) / 2
               end
    banner.update(position: position)
  end

  member_action :publish, method: :post do
    Banner.find(params[:id]).publish!
    redirect_back fallback_location: admin_crowdfunding_banners_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    Banner.find(params[:id]).unpublish!
    redirect_back fallback_location: admin_crowdfunding_banners_url, notice: '取消发布成功'
  end
end
