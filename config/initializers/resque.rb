Resque.redis = ENV['CACHE_RESQUE_PATH']
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
puts 'after resque initialized'