class TicketUploader < RacePhotoUploader
  process resize_to_limit: [900, nil]

  def store_dir
    "uploads/ticket/#{mounted_as}/#{model.id}"
  end
end
