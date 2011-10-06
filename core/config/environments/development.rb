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
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
end

Rails.logger = Logger.new(STDOUT)

# cache_classes on, but don't cache views (over requests)
# http://madebynathan.com/2011/02/10/rails3-is-caching-views-in-development-mode-but-i-told-it-not-to/
ActiveSupport.on_load(:after_initialize) do
  ActionController::Base.before_filter do
    ActionController::Base.view_paths.each(&:clear_cache)
  end
end

# this allows WEBrick to handle pipe symbols in query parameters
puts "Overriding default URI parser to add pipe"
URI::DEFAULT_PARSER = URI::Parser.new(:UNRESERVED => URI::REGEXP::PATTERN::UNRESERVED + '|')