# This is the normal spec_helper, excluding the Devise section
require 'rubygems'

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

# Integration helper specific:

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller
end

Devise.setup do |config|
  # Set the number of stretches to 1 for your test environment to speed up
  # unit tests: https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests

  # Using less stretches will increase performance dramatically if you use
  # bcrypt and create a lot of users (i.e. you use FactoryGirl or Machinist).
  config.stretches = 1
end

require 'capybara/rspec'

Capybara.javascript_driver = :webkit

def int_user
  user = Factory.create(:user, email: "user@example.com")
  user.confirm!
  user
end

def handle_js_confirm(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
  page.evaluate_script "window.confirm = window.original_confirm_function"
end