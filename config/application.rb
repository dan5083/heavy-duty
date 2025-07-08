# config/application.rb

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HeavyDuty
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # NEW: Session configuration for impersonation security
    config.session_store :cookie_store,
                         key: '_heavy_duty_session',
                         secure: Rails.env.production?,
                         httponly: true,
                         same_site: :lax,
                         expire_after: 24.hours
  end
  # Email configuration for production
  if Rails.env.production?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.default_url_options = {
      host: 'heavy-duty-1bf635cff355.herokuapp.com',
      protocol: 'https'
    }
    config.action_mailer.smtp_settings = {
      address: ENV['MAILGUN_SMTP_SERVER'],
      port: ENV['MAILGUN_SMTP_PORT'].to_i,
      domain: ENV['MAILGUN_DOMAIN'],
      user_name: ENV['MAILGUN_SMTP_LOGIN'],
      password: ENV['MAILGUN_SMTP_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end
end
