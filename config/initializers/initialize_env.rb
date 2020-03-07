jpush_vars = %w(JPUSH_APP_KEY JPUSH_MASTER_SECRET JPUSH_APNS_PRODUCTION)
# ucloud_vars = %w(UCLOUD_BUCKET UCLOUD_BUCKET_HOST UCLOUD_CDN_HOST)
upyun_vars = %w(UPYUN_USERNAME UPYUN_PASSWD UPYUN_BUCKET UPYUN_BUCKET_HOST)
cache_vars = %w(CACHE_DATABASE_TYPE CACHE_DATABASE_PATH)
current_vars = %w(CURRENT_PROJECT_ENV CURRENT_PROJECT)
env_vars = current_vars + jpush_vars + upyun_vars + cache_vars
env_vars.each do |var|
  if ENV[var].nil?
    raise "环境变量 #{var} 必须存在"
  end
end