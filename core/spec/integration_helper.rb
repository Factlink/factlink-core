ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rubygems'
require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara/email/rspec'
require 'headless'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # webkit always has js enabled, so always use this:
  Capybara.javascript_driver = :webkit
  Capybara.default_driver = :webkit
  Capybara.default_wait_time = 5

  config.pattern = "**/*_spec.rb"
  config.mock_with :rspec

  config.include Acceptance
  config.include FactoryGirl::Syntax::Methods
  config.include ScreenshotTest

  config.before(:suite) do
    # Use the headless gem to manage your Xvfb server
    # So not destroy X server in case
    Headless.new(destroy_on_exit: false).start
    ElasticSearch.create
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    stub_const("Logger", Class.new)
    stub_const("Logger::ERROR", 1)
    stub_const("Logger::INFO", 2)
    stub_const("Logger::LOG", 3)
    stub_const("Logger::DEBUG", 4)
    Logger.stub(new: nil.andand)
    ElasticSearch.clean
    Ohm.flush
    DatabaseCleaner.clean
    FactoryGirl.reload
  end
end

Devise.setup do |config|
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 1    # should be low to improve performance. But should not be 0
end
