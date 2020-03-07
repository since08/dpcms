require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
# load .env
Dotenv::Railtie.load
module Dpcms
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = 'zh-CN'
    config.time_zone = 'Beijing'

    config.cache_store = config_for(:cache_store)

    $settings = config_for(:settings)

    config.active_job.queue_adapter = :resque

    # auto_load
    config.autoload_paths += [
        Rails.root.join('lib')
    ]

    # eager_load
    config.eager_load_paths += [
        Rails.root.join('lib/qcloud'),
        Rails.root.join('lib/dp_push')
    ]

    # sanitize 自定义白名单
    config.action_view.sanitized_allowed_tags = Set.new(%w(strong em b i p code pre tt samp kbd var sub
        sup dfn cite big small address hr br div span h1 h2 h3 h4 h5 h6 ul ol li dl dt dd abbr
        acronym a img blockquote del ins video))

    config.action_view.sanitized_allowed_attributes = Set.new(%w(href src width
        height alt cite datetime title class name xml:lang abbr controls poster))
  end
end
