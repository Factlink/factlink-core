RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :controller
end

module Devise
  module Models
    module DatabaseAuthenticatable
      protected
        def password_digest(password)
          password
        end
    end
  end
end

Devise.setup do |config|
  config.stretches = 0
end
