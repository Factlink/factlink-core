require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module FactlinkUI
  class Application < Rails::Application
    # Auto load files in lib directory
    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/classes"
    config.autoload_paths << "#{config.root}/app/ohm-models"

    autoload :FactData, "#{config.root}/app/models/fact_data.rb"
    autoload :User, "#{config.root}/app/models/user.rb"
    
    autoload :OurOhm, "#{config.root}/app/ohm-models/our_ohm.rb"
    autoload :FactGraph, "#{config.root}/app/ohm-models/fact_graph.rb"
    autoload :Basefact, "#{config.root}/app/ohm-models/basefact.rb"
    autoload :Fact, "#{config.root}/app/ohm-models/fact.rb"
    autoload :FactRelation, "#{config.root}/app/ohm-models/fact_relation.rb"
    autoload :GraphUser, "#{config.root}/app/ohm-models/graph_user.rb"
    autoload :Site, "#{config.root}/app/ohm-models/site.rb"
    autoload :Channel, "#{config.root}/app/ohm-models/channel.rb"
    
    autoload :Opinion, "#{config.root}/app/ohm-models/opinion.rb"
    
    
    autoload :Activity, "#{config.root}/app/ohm-models/activities.rb"
    autoload :ActivitySubject, "#{config.root}/app/ohm-models/activities.rb"
    
    [
      OurOhm, 
      Activity,
      ActivitySubject,
      FactGraph, 
      Opinion, 
      Basefact, 
      FactData, 
      Fact, 
      FactRelation, 
      GraphUser, 
      Site,
      Channel
    ].each do |x|
       puts "loaded " + x.to_s
    end
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Use Mongoid as ORM
    config.generators do |g|
      g.orm             :mongoid
    end

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

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
    config.filter_parameters += [:password]
    
  end
end
