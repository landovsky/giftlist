require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Giftlist
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.eager_load_paths += %W( #{config.root}/lib )
    #zlobí config.autoload_paths << Rails.root.join("/app/validators/")
    config.autoload_paths << Rails.root.join('lib')
    #config.active_job.queue_adapter = :delayed_job
    config.active_job.queue_adapter = :async
    config.web_console.whitelisted_ips = '172.19.0.1'
  end
end
