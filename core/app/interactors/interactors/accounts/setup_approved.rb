require 'pavlov'

module Interactors
  module Accounts
    class SetupApproved
      include Pavlov::Interactor

      arguments :reset_password_token, :attribuutjes

      def authorized?
        true
      end

      def execute
        user = User.find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
        if user.persisted?
          user.attributes = attribuutjes.slice(:first_name, :last_name)
          user.reset_password!(attribuutjes[:password], attribuutjes[:password_confirmation])
        end
        user
      end

      def validate
        validate_nonempty_string :reset_password_token, reset_password_token
      end
    end
  end
end
