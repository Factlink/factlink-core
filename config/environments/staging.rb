FactlinkUI::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Error reporting
  # config.middleware.use ExceptionNotifier,
  #   :email_prefix => "[FL##{Rails.env}] ",
  #   :sender_address => %{"#{Rails.env} - FL - Bug notifier" <team+bugs@factlink.com>},
  #   :exception_recipients => %w{team+bugs@factlink.com}

  # The staging environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = false

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new
  # config.logger = RavenLogger.new(STDOUT)

  # Use a different cache store in staging
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In staging, Apache or nginx will already do this
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglify
  config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  I18n.default_locale = FactlinkUI.Kennisland? ? :kl : :en

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Redirect all traffic to https equivalent. Add 'secure' flag to cookie.
  config.force_ssl = true
end

require File.expand_path("./config/email_configuration")
