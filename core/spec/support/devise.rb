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
