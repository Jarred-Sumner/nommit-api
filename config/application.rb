require File.expand_path('../boot', __FILE__)

require 'rails/all'

COMPANY_PHONE = "(415) 273-9617" unless defined?(COMPANY_PHONE)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NommitApi
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app/workers')
    config.autoload_paths << Rails.root.join('app/interactors')
    config.assets.precompile += %w(login.js dashboard.js)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.secret_token = ENV["SECRET_TOKEN"]

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :authentication => :plain,
      :address => ENV["SMTP_HOSTNAME"],
      :port => 587,
      :domain => ENV["SMTP_DOMAIN"],
      :user_name => ENV["SMTP_USERNAME"],
      :password => ENV["SMTP_PASSWORD"]
    }

    config.action_controller.perform_caching = true
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.action_mailer.default_url_options = { host: "localhost:3000" }
    config.asset_host = "http://localhost:3000"
  end
end
