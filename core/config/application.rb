require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "pavlov/alpha_compatibility"

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
    config.autoload_paths << "#{config.root}/app/observers"
    config.autoload_paths << "#{config.root}/app/interactors"

    config.log_level = :info

    config.mongoid.observers = :user_observer, :topic_observer, :fact_data_observer

    require_dependency "#{config.root}/app/classes/map_reduce.rb"
    require_dependency "#{config.root}/app/classes/redis_utils.rb"
    require_dependency "#{config.root}/app/ohm-models/our_ohm.rb"
    require_dependency "#{config.root}/app/ohm-models/activity.rb"
    require_dependency "#{config.root}/app/ohm-models/authority.rb"
    require_dependency "#{config.root}/app/ohm-models/fact_graph.rb"
    require_dependency "#{config.root}/app/ohm-models/basefact.rb"
    require_dependency "#{config.root}/app/models/fact_data.rb"
    require_dependency "#{config.root}/app/ohm-models/fact.rb"
    require_dependency "#{config.root}/app/ohm-models/fact_relation.rb"
    require_dependency "#{config.root}/app/ohm-models/site.rb"
    require_dependency "#{config.root}/app/ohm-models/channel.rb"
    require_dependency "#{config.root}/app/ohm-models/graph_user.rb"

    Rails.application.config.generators.template_engine :erb

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Use Mongoid as ORM
    config.generators do |g|
      g.orm             :mongoid
    end

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Block frame busting for all routes except the intermediate
    # If you update this route, also update it here please.
    #
    # Why?
    # - /factlink/intermediate  : Loaded in iframe through JS Library
    # - /facts/new              : Loaded in iframe through Chrome Extension (popup)
    # config.middleware.use Rack::XFrameOptions, "SAMEORIGIN", ["/factlink/intermediate", "/facts/new"]


    config.middleware.insert_before("Rack::Lock", "Rack::Rewrite") do
      r301 %r{^\/(.+)\/(\?.*)?$}, '/$1$2'
    end

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

    config.assets.precompile = [
      /\w+\.(?!js|css|less).+/,
      'activity.css',
      'admin.css',
      'fake_facts.css',
      'frontend.css',
      'client.css',
      'popup.css',
      'privacy.css',
      'search.css',
      'tos.css',
      'tour.css',
      'social_popup.css',
      'pages.css',
      'base.css',
      'application.js',
      'feedback.js',
      'frontend.js',
      'modal.js',
      'popup.js',
      'intermediate.js',
      'modernizr-loader.js',
      'admin.js',
    ]

    # Precompile additional assets
    config.assets.precompile += %w( .svg .eot .woff .ttf )

    # we only cache very little, so memory_store is fine for now
    config.cache_store = :memory_store


    config.less.paths << File.join(config.root, 'vendor', 'frameworks')

  end
end

version_file = File.new('version.txt','r')
FactlinkUI::Application.config.version_number = version_file.gets.chomp
version_file.close


# Securityfix:
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
#puts "Here comes a warning because we are very secure:"
#ActionDispatch::ParamsParser::DEFAULT_PARSERS={}
