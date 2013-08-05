unless defined?(I_AM_SPEC_HELPER)
I_AM_ACCEPTANCE_HELPER = true

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rubygems'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/email/rspec'
require 'capybara-screenshot/rspec'
require 'database_cleaner'
require "timeout"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each {|f| require f}

RSpec.configure do |config|
  config.filter_run_excluding slow: true unless ENV['RUN_SLOW_TESTS']

  # webkit always has js enabled, so always use this:
  driver = if ENV["USE_SELENIUM"] then :selenium else :poltergeist end

  Capybara.javascript_driver = driver
  Capybara.default_driver = driver

  Capybara.default_wait_time = 5
  Capybara.server_port = 3005

  config.mock_with :rspec

  config.fail_fast = false

  config.include Acceptance
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    ElasticSearch.create
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, { debug: false,
                                               js_errors: false,
                                               timeout: 60 })
    end

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

    ElasticSearch.stub synchronous: true
  end

  config.after(:each) do
    Timeout.timeout(Capybara.default_wait_time) do
      # wait for all ajax requests to complete
      # if we don't wait, the server may see it after the db is cleaned
      # and a request for a removed object will cause a crash (nil ref).
      sleep(0.1) until page.evaluate_script('jQuery.active') == 0
    end
    Capybara.reset!
  end
end

Devise.setup do |config|
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 1    # should be low to improve performance. But should not be 0
end

end # don't load if spec_helper is loaded
