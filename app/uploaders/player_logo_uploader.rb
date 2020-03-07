class PlayerLogoUploader < BaseUploader
  def store_dir
    "uploads/players/#{mounted_as}/#{model.id}"
  end
end