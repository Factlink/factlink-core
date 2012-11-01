FactlinkUI::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.delivery_method = :letter_opener

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # These options belong here
  config.action_mailer.default_url_options = { :host => 'localhost', :port => '3000' }

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  I18n.default_locale = :nl

  config.force_ssl = false

  config.action_controller.perform_caching = true

  $stdout.sync = true

  config.lograge.enabled = true

  config.dev_tweaks.log_autoload_notice = false
end


silence_warnings do
  begin
    #only require this gem if we're starting a console
    if Rails.const_defined?(:Console)
      require 'pry'
      IRB = Pry
    end
  rescue LoadError
    puts "Error: Failed on loading Pry as shell"
  end
end

Rails.logger = Logger.new(STDOUT)

# cache_classes on, but don't cache views (over requests)
# http://madebynathan.com/2011/02/10/rails3-is-caching-views-in-development-mode-but-i-told-it-not-to/
ActiveSupport.on_load(:after_initialize) do
  ActionController::Base.before_filter do
    ActionController::Base.view_paths.each(&:clear_cache)
  end
end

require 'ruby-prof'
