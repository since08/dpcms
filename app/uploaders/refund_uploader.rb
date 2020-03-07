class RefundUploader < BaseUploader
  def store_dir
    "uploads/refund/#{mounted_as}/#{model.id}"
  end
end