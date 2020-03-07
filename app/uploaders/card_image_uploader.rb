class CardImageUploader < BaseUploader
  def store_dir
    md5 = model["#{mounted_as}_md5".to_sym]
    "card_image/#{md5[0, 3]}/#{md5[3, 3]}"
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def filename
    md5 = model["#{mounted_as}_md5".to_sym]
    "#{md5}#{File.extname(super)}" if super
  end
end

