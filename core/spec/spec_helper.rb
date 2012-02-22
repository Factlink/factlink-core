require 'simplecov'
SimpleCov.start

require 'rubygems'


# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


module Devise
  module Models
    module DatabaseAuthenticatable
      protected
        def password_digest(password)
          password
        end
    end
  end
end
Devise.setup do |config|
  config.stretches = 0
end

RSpec.configure do |config|
  #mix in FactoryGirl methods
  config.include Factory::Syntax::Methods

  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerMethods, type: :controller

  config.mock_with :rspec
  require 'database_cleaner'

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    Ohm.flush
    DatabaseCleaner.clean
  end

  # config.after(:each, type: :controller) do
  #   unless @dont_check_frame_options
  #     if response.content_type == "html"
  #       last_response.headers['X-Frame-Options'].should == 'SAMEORIGIN'
  #     end
  #   end
  # end

  config.after(:suite) do
    Ohm.flush
    DatabaseCleaner.clean
  end
end

