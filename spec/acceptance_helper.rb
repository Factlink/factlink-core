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
require 'webmock'
require 'capybara-screenshot/rspec'
require 'database_cleaner'
require 'sucker_punch/testing/inline'

require 'pavlov_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# Don't do web requests from tests
WebMock.disable_net_connect!(:allow_localhost => true)

RSpec.configure do |config|
  config.filter_run_excluding slow: true unless ENV['RUN_SLOW_TESTS']

  Capybara.register_driver :poltergeist do |app|
    options = {
      debug: false,
      js_errors: true,
      timeout: 60,
      phantomjs_options: ['--load-images=no'],
    }
    Capybara::Poltergeist::Driver.new(app, options)
  end

  Capybara.register_driver :selenium do |app|
    browser = if ENV["USE_SELENIUM"].nil? || ENV["USE_SELENIUM"].empty?
                :firefox
              else
                ENV["USE_SELENIUM"].to_sym
              end
    Capybara::Selenium::Driver.new(app, browser: browser)
  end

  driver = if ENV["USE_SELENIUM"]
             :selenium
           else
             :poltergeist
           end

  Capybara.javascript_driver = driver
  Capybara.default_driver = driver

  Capybara.server do |app, port|
    require 'rack/handler/thin'
    Rack::Handler::Thin.run(app, :Port => port)
  end

  Capybara.default_wait_time = 5
  Capybara.server_port = 3005

  if ENV["CIRCLE_ARTIFACTS"]
    Capybara.save_and_open_page_path = "#{ENV["CIRCLE_ARTIFACTS"]}/capybara_output"
  else
    FileUtils.rm_rf(Dir.glob("#{Capybara.save_and_open_page_path}/*"))
  end

  config.mock_with :rspec

  config.include Acceptance
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    Capybara.reset!
    DatabaseCleaner.clean
    FactoryGirl.reload
    Capybara::Screenshot.autosave_on_failure = true
  end

  config.before(:each) do
    enable_global_features # always enable global features even if there aren't any, otherwise the screenshots will change.
  end

  config.after(:each) do
    execute_script 'localStorage.clear();sessionStorage.clear();'

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
