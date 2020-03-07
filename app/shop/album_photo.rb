# rubocop:disable Metrics/BlockLength
ActiveAdmin.register AlbumPhoto, namespace: :shop do
  config.batch_actions = false
  config.filters = false
  config.clear_action_items!
  actions :all, except: :index
  permit_params :image, :album_id
  menu parent: '相册管理'

  controller do
    def destroy
      resource.destroy
      render layout: false
    end
  end

  action [], :index, method: :get do
    @page_title = '相册图片'
    respond_to do |format|
      format.js
      format.html { render layout: 'layouts/active_admin' }
    end
  end

  collection_action :quick_add, method: :get do
    @album = Album.find_by(id: params[:album_id])
    @photo = AlbumPhoto.new
    render layout: false
  end

  collection_action :quick_create, method: :post do
    params[:album_photo][:image].each do |img|
      @photo = AlbumPhoto.new(image: img, album_id: params[:album_photo][:album_id])
      @photo.save
    end
    render 'quick_response', layout: false
  end
end
