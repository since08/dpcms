class PhotosController < ApplicationController
  def create
    @photo = Photo.new
    @photo.image = params[:image]
    @photo.user = current_admin_user
    if @photo.save
      render json: { success: true, msg: '上传成功', file_path: @photo.image.url }
    else
      render json: { success: false }
    end
  end
end
