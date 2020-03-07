# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Album, namespace: :shop do
  config.batch_actions = false
  config.filters = false
  navigation_menu :default
  menu parent: '相册管理'
  permit_params :name

  controller do
    before_action :exist_photos?, only: [:destroy]

    def exist_photos?
      @album = Album.find(params[:id])
      return unless @album.photos.exists?

      flash[:error] = '该相册下有图片，不允许删除'
      redirect_back fallback_location: shop_albums_url
    end
  end

  collection_action :quick_add, method: :get do
    @album = Album.new
    render layout: false
  end

  collection_action :quick_create, method: :post do
    @album = Album.new(permitted_params[:album])
    @album.save
    render 'quick_response', layout: false
  end

  member_action :photos, method: :get do
    @album_id = params[:id].to_i
    @photos = if @album_id.zero?
                AlbumPhoto
              else
                Album.find(@album_id).photos
              end.order(id: :desc).page(params[:page])

    respond_to do |format|
      format.js { render 'photos', layout: false }
    end
  end
end
