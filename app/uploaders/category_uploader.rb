class CategoryUploader < BaseUploader
  process resize_to_limit: [512, nil]
end
