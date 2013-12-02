unless defined?(I_AM_SPEC_HELPER)
I_AM_ACCEPTANCE_HELPER = true

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rubygems'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/email/rspec'
require 'capybara-screenshot'
require 'test_request_syncer'
require 'poltergeist_style_overrides'

require 'capybara-screenshot/rspec'
require 'database_cleaner'

require 'pavlov_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each {|f| require f}

# Don't do web requests from tests
WebMock.disable_net_connect!(:allow_localhost => true)

RSpec.configure do |config|
  config.filter_run_excluding slow: true unless ENV['RUN_SLOW_TESTS']

  # webkit always has js enabled, so always use this:
  driver = if ENV["USE_SELENIUM"] then :selenium else :poltergeist end

  Capybara.javascript_driver = driver
  Capybara.default_driver = driver

  Capybara.default_wait_time = 5
  Capybara.server_port = 3005

  config.mock_with :rspec

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
    Authority.logger = nil
  end

  config.before(:each) do
    Capybara.reset!
    ElasticSearch.clean
    Ohm.flush
    DatabaseCleaner.clean
    FactoryGirl.reload

    ElasticSearch.stub synchronous: true
  end

  config.after(:each) do
    TestRequestSyncer.increment_counter
    # after incrementing the counter, no new ajax requests will *start* to run.
    # However, ruby *is* multithreaded, so existing ajax requests must be
    # allowed to terminate.  The most efficient way of doing this would be to
    # use a lock, but this is much simpler and 99% ok...
    wait_for_ajax_idle
  end
end

Devise.setup do |config|
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 1    # should be low to improve performance. But should not be 0
end

end # don't load if spec_helper is loaded
