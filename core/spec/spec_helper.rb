ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rubygems'
require 'database_cleaner'

begin
  require 'simplecov'
  SimpleCov.start
rescue
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # Exclude integration tests in normal suite
  config.filter_run_excluding type: :request
  config.pattern = "**/*_spec.rb"
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods
  config.include ControllerMethods, type: :controller

  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    Ohm.flush
    DatabaseCleaner.clean
    ElasticSearchCleaner.clean
  end

  config.after(:suite) do
    Ohm.flush
    DatabaseCleaner.clean
    ElasticSearchCleaner.clean
  end
end

# Speed improvements in password hashing
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
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 0
end
