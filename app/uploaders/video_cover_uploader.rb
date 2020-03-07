class VideoCoverUploader < BaseUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :preview do
    process resize_to_fit: [224, 148]
  end
end
