unless defined?(I_AM_ACCEPTANCE_SPEC_HELPER)

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

I_AM_SPEC_HELPER = true

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| puts f; require f}

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
    ElasticSearch.create
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    ElasticSearch.clean
    stub_const("Logger", Class.new)
    stub_const("Logger::ERROR", 1)
    stub_const("Logger::INFO", 2)
    stub_const("Logger::LOG", 3)
    stub_const("Logger::DEBUG", 4)
    Logger.stub(new: nil.andand)

    Ohm.flush
    DatabaseCleaner.clean
    Timecop.return
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

end # don't load if acceptance_helper is loaded
