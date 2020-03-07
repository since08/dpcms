class ActivityUploader < RacePhotoUploader
  process resize_to_limit: [900, nil]

  def store_dir
    "uploads/activity/#{mounted_as}/#{model.id}"
  end
end
