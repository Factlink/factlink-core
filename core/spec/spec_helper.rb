require 'simplecov'
SimpleCov.start

require 'rubygems'

require 'capybara/rspec'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


RSpec.configure do |config|
  #mix in FactoryGirl methods
  config.include Factory::Syntax::Methods

  config.include ControllerMethods, type: :controller

  config.pattern = "**/*_spec.rb"

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

  config.after(:suite) do
    Ohm.flush
    DatabaseCleaner.clean
  end
end

