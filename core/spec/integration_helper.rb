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

  config.pattern = "**/*_spec.rb"
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods
  config.include ControllerMethods, type: :controller
  config.include ScreenshotTest

  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller

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
    Logger.stub(new: nil.andand)
    ElasticSearch.clean
    Ohm.flush
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    Ohm.flush
    DatabaseCleaner.clean
  end
end

Devise.setup do |config|
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 1    # should be low to improve performance. But should not be 0
end

def int_user
  user = FactoryGirl.create(:user)
  user.confirm!
  user
end

def handle_js_confirm(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
  page.evaluate_script "window.confirm = window.original_confirm_function"
end

def create_admin_and_login
  admin = FactoryGirl.create(:admin_user)
  sign_in_user admin
end

def make_non_tos_user_and_login
  user = FactoryGirl.create(:approved_confirmed_user, agrees_tos: false)
  sign_in_user(user)
end

def sign_in_user(user)
  visit "/"
  click_link "Sign in"
  fill_in "user_login", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Sign in"

  user
end

def random_username
  @username_sequence ||= FactoryGirl::Sequence.new :username do |n|
    "janedoe#{n}"
  end

  @username_sequence.next
end

def random_email
  @email_sequence ||= FactoryGirl::Sequence.new :email do |n|
    "janedoe#{n}@example.com"
  end

  @email_sequence.next
end

def wait_for_ajax
  begin
    wait_until { page.evaluate_script('jQuery.active') > 0 }
  rescue Capybara::TimeoutError
    puts 'No Ajax request was made, what are you waiting for?'
  end
  wait_until { page.evaluate_script('jQuery.active') == 0 }
rescue Capybara::TimeoutError
  flunk 'The Ajax request was not ready in time'
end

def wait_until_scope_exists(scope, &block)
  wait_until { page.has_css?(scope) }
  within scope, &block
rescue Capybara::TimeoutError
  flunk "Expected '#{scope}' to be present."
end

def disable_html5_validations(page)
  page.execute_script "$('form').attr('novalidate','novalidate')"
end
