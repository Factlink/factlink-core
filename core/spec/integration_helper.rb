ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rubygems'
require 'capybara/rspec'
require 'capybara-webkit'
require 'headless'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  config.pattern = "**/*_spec.rb"
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods
  config.include ControllerMethods, type: :controller

  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller

  config.before(:suite) do
    # Use the headless gem to manage your Xvfb server
    # So not destroy X server in case
    Headless.new(destroy_on_exit: false).start

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

Devise.setup do |config|
  # https://github.com/plataformatec/devise/wiki/Speed-up-your-unit-tests
  config.stretches = 1    # should be low to improve performance. But should not be 0
end

def int_user
  user = FactoryGirl.create(:user, email: "user@example.com")
  user.confirm!
  user
end

def handle_js_confirm(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
  page.evaluate_script "window.confirm = window.original_confirm_function"
end

def make_user_and_login
  user = FactoryGirl.create(:user, email: "user@example.com", approved: true)
  sign_in_user(user)
end

def make_non_tos_user_and_login
  user = FactoryGirl.create(:user, email: "user@example.com", agrees_tos: false, approved: true)
  sign_in_user(user)
end

def sign_in_user(user)
  user.confirm!
  visit "/"
  fill_in "user_login", :with => user.email
  fill_in "user_login_password", :with => user.password
  click_button "Sign in"

  user
end

# Nice post about comparing images:
# http://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/
def compare folder
  path = Rails.root.join "#{Capybara.save_and_open_page_path}" "#{folder}"
end

def assume_unchanged_screenshot title
  filename = "screenshot-#{title}-new"
  screen_shot_and_save_page filename
  if compare_two_images(Rails.root.join('spec','integration','screenshots',"#{title}.png"),Rails.root.join("#{Capybara.save_and_open_page_path}" "#{filename}.png"), Rails.root.join("#{Capybara.save_and_open_page_path}" "screenshot-#{title}-diff.png"))
    raise "Screenshot #{title} changed"
  end
end

def screen_shot_and_save_page filename="#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}"
  require 'capybara/util/save_and_open_page'
  Capybara.save_page body, "/#{filename}.html"
  page.driver.render Rails.root.join "#{Capybara.save_and_open_page_path}" "#{filename}.png"
end

include ChunkyPNG::Color

def compare_two_images file1, file2, diff

  images = [
    ChunkyPNG::Image.from_file(file1),
    ChunkyPNG::Image.from_file(file2)
  ]

  changed = false

  images.first.height.times do |y|
    images.first.row(y).each_with_index do |pixel, x|
      changed ||= images.last[x,y] != pixel
      images.last[x,y] = rgb(
        r(pixel) + r(images.last[x,y]) - 2 * [r(pixel), r(images.last[x,y])].min,
        g(pixel) + g(images.last[x,y]) - 2 * [g(pixel), g(images.last[x,y])].min,
        b(pixel) + b(images.last[x,y]) - 2 * [b(pixel), b(images.last[x,y])].min
      )
    end
  end

  images.last.save(diff)
  changed
end
