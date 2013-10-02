module Interactors
  module Accounts
    class SetupApproved
      include Pavlov::Interactor

      arguments :user, :attribuutjes

      def authorized?
        true
      end

      def execute
        if user.persisted?
          user.attributes = attribuutjes.slice(:first_name, :last_name)
          user.set_up = true

          user.reset_password!(attribuutjes[:password], attribuutjes[:password_confirmation])
        end

        user
      end
    end
  end
end
