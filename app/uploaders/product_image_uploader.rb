class ProductImageUploader < BaseUploader
  process :crop

  def store_dir
    "uploads/products/#{model.viewable_type}/#{model.viewable_id}"
  end
end
