class RacePhotoUploader < BaseUploader
  process resize_to_limit: [900, nil]

  def store_dir
    "uploads/race/#{mounted_as}/#{model.id}"
  end
end
