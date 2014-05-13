require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_record/railtie"
require "pavlov/alpha_compatibility"

if ENV['HEROKU']
  require "rails_12factor"
end

Mime::Type.register "image/png", :png unless Mime::Type.lookup_by_extension(:png)
Mime::Type.register "image/gif", :gif unless Mime::Type.lookup_by_extension(:gif)

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end
require 'coffee_script'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(:default, Rails.env) if defined?(Bundler)

ActiveSupport.escape_html_entities_in_json = true

module FactlinkUI
  class Application < Rails::Application
    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/classes"
    config.autoload_paths << "#{config.root}/app/entities"
    config.autoload_paths << "#{config.root}/app/ohm-models"
    config.autoload_paths << "#{config.root}/app/workers"
    config.autoload_paths << "#{config.root}/app/interactors"

    config.log_level = :info

    Rails.application.config.generators.template_engine :erb

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.orm             :active_record
    end

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    config.middleware.insert 0, Rack::Rewrite do
      r301 %r{^\/(.+)\/(\?.*)?$}, '/$1$2'
    end

    config.action_dispatch.default_headers = {
      # NOT 'X-Frame-Options' => 'SAMEORIGIN',
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff'
    }

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Add /app/templates to asset path
    config.assets.paths << Rails.root.join("app", "templates")

    # Add /app/assets/fonts to asset path
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    # Add /app/backbone to asset path
    config.assets.paths << Rails.root.join("app", "backbone")

    # Add the fonts path
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += [
      /\w+\.(?!js|css|less).+/,

      'admin.css',
      'application.css',
      'base.css',
      'unsubscribed.css',

      'application.js',
      'admin.js',
      'jquery.js',

      'factlink_loader.js',
      'factlink_loader.min.js',
    ]

    # Precompile additional assets
    config.assets.precompile += %w( .svg .eot .woff .ttf )

    # For old static jslib paths
    config.assets.prefix = "/lib/dist"

    # we only cache very little, so memory_store is fine for now
    config.cache_store = :memory_store

    config.i18n.enforce_available_locales = true
  end
end
begin
  version_file = File.new('GIT_REVISION','r')
  FactlinkUI::Application.config.version_number = version_file.gets.chomp
  version_file.close
rescue
  FactlinkUI::Application.config.version_number = 'unknown'
end

require_relative './initializers/core.rb'

FactlinkUI::Application.config.support_email = ENV.fetch('FACTLINK_SUPPORT_EMAIL', 'support@factlink.com')
FactlinkUI::Application.config.support_name = ENV.fetch('FACTLINK_SUPPORT_NAME', 'Factlink')

# Securityfix:
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
#puts "Here comes a warning because we are very secure:"
#ActionDispatch::ParamsParser::DEFAULT_PARSERS={}
