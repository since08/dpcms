class ProductUploader < BaseUploader
  process :crop

  def store_dir
    "uploads/products/#{model.id}/#{mounted_as}"
  end

  # 在 UpYun 配置图片缩略图
  # http://docs.upyun.com/guide/#_12
  # 固定宽度,高度自适应
  # xs - 100
  # sm - 200
  # md - 500
  # lg - 1080

  ALLOW_VERSIONS = %w(xs sm md lg).freeze
  def url(version_name = nil)
    @url ||= super({})
    return @url if version_name.blank?

    version_name = version_name.to_s
    unless version_name.in?(ALLOW_VERSIONS)
      raise "ImageUploader version_name:#{version_name} not allow."
    end

    [@url, version_name].join('!')
  end
end
