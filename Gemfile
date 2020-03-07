# source 'https://rubygems.org'
source 'https://gems.ruby-china.com'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.0'
gem 'uglifier', '>= 1.3.0'
gem 'dotenv-rails'

# cache 相关
gem 'redis-rails', '~> 5.0', '>= 5.0.2'
gem 'second_level_cache', '~> 2.3.0'
gem 'leaderboard'

# view 相关
gem 'haml'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5'
gem 'simditor'
gem 'awesome_nested_set'
gem 'fancybox2-rails'
gem 'remotipart'

# activeadmin 相关
gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin'
gem 'devise'
gem 'rails-i18n'
gem 'redcarpet'

# 文件处理组件
gem 'carrierwave', '~> 1.0'
# gem 'carrierwave-ucloud', '~> 0.0.2'
gem 'carrierwave-upyun'
gem 'mini_magick'
gem 'roo'
gem 'roo-xls'

# 压缩图片
gem 'image_optim'
gem 'image_optim_pack'
gem 'carrierwave-imageoptim'

# resque
gem 'resque'
# Whenever is a Ruby gem that provides a clear syntax for writing and deploying cron jobs.
gem 'whenever', '~> 0.10.0', require: false

# http组件
gem 'faraday','~> 0.11.0'

gem 'jpush', '~> 4.0', '>= 4.0.6'

gem 'best_in_place', github: 'bernat/best_in_place'
gem 'kuaidiniao'
gem 'font-awesome-rails'

# 微信支付
gem 'wx_pay'

# charts相关
gem 'chartkick'
gem 'groupdate'

gem 'jmessage'

# 附近的人
gem 'geocoder'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano3-puma'
  gem 'capistrano-rvm'
  gem 'capistrano-resque', require: false
  gem 'rubocop', '0.46.0', require: false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'pry-rails'
  gem 'awesome_print'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
