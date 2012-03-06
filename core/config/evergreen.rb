require 'capybara-webkit'

Evergreen.configure do |config|
  config.driver = :webkit
  config.public_dir = 'public'
  config.spec_dir = 'spec/javascripts'
  config.template_dir = 'spec/javascripts/templates'
end