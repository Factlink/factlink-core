require 'acceptance_helper'
require 'capybara-screenshot'

RSpec.configure do |config|
  config.include ScreenshotTest
  config.running_screenshot_tests = true
end
Capybara::Screenshot.autosave_on_failure = false
