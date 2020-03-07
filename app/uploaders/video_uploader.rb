class VideoUploader < BaseUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(mov avi mp4 mkv wmv mpg 3gp)
  end
end
