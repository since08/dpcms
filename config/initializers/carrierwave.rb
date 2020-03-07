CarrierWave.configure do |config|
  # config.storage = :ucloud
  # config.public_key = 'wtzkb/5oUfZoeDgrz5r0fc85/krg7UkS8OLLwSVPuvtxd0RX9Vm/+w=='
  # config.private_key = '6a0d76a6d5f7be5248ed4745626aa04fe82d4ef2'
  # config.ucloud_bucket = ENV['UCLOUD_BUCKET']
  # config.ucloud_bucket_host = ENV['UCLOUD_BUCKET_HOST']
  # config.ucloud_cdn_host = ENV['UCLOUD_CDN_HOST']
  if Rails.env.test?
    config.storage = :file
  else
    config.storage = :upyun
    config.upyun_username    = ENV['UPYUN_USERNAME']
    config.upyun_password    = ENV['UPYUN_PASSWD']
    config.upyun_bucket      = ENV['UPYUN_BUCKET']
    config.upyun_bucket_host = ENV['UPYUN_BUCKET_HOST']
  end
end
