# rubocop:disable Metrics/BlockLength
HEADLINE_SOURCE_TYPE = %w(race info video).freeze
TRANS_HEADLINE_SOURCE_TYPE = HEADLINE_SOURCE_TYPE.collect { |d| [I18n.t("activerecord.models.#{d}"), d] }
ActiveAdmin.register Headline do
  menu priority: 5, parent: '首页管理'
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_asc'

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    def create
      position = (Headline.last&.id.to_i + 1) * 100000
      merge_params = { position: position, source_type: headline_params[:source_type].classify }
      @headline = Headline.new headline_params.merge(merge_params)

      if @headline.save
        flash[:notice] = '新建头条成功'
        redirect_to admin_headlines_url
      else
        render :new
      end
    end

    def headline_params
      params.require(:headline).permit(:title,
                                       :source_id,
                                       :source_type)
    end
  end

  member_action :reposition, method: :post do
    headline = Headline.find(params[:id])
    next_headline = params[:next_id] && Headline.find(params[:next_id].split('_').last)
    prev_headline = params[:prev_id] && Headline.find(params[:prev_id].split('_').last)
    position = if params[:prev_id].blank?
                 next_headline.position / 2
               elsif params[:next_id].blank?
                 prev_headline.position + 100000
               else
                 (prev_headline.position + next_headline.position) / 2
               end
    headline.update(position: position)
  end

  member_action :publish, method: :post do
    Headline.find(params[:id]).publish!
    redirect_back fallback_location: admin_headlines_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    Headline.find(params[:id]).unpublish!
    redirect_back fallback_location: admin_headlines_url, notice: '取消发布成功'
  end
end
