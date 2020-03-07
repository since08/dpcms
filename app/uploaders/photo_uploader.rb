class PhotoUploader < BaseUploader
  include CarrierWave::ImageOptim
  process :optimize

  def filename
    today = Time.zone.today
    # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
    @name ||= Digest::MD5.hexdigest(current_path)
    "#{today.strftime('%Y/%m')}/#{@name}.#{file.extension.downcase}"
  end
end
