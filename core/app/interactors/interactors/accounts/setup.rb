module Interactors
  module Accounts
    class Setup
      include Pavlov::Interactor

      arguments :user, :attribuutjes

      def authorized?
        true
      end

      def execute
        user.attributes = attribuutjes.slice(:first_name, :last_name)
        user.set_up = true
        user.reset_password!(attribuutjes[:password], attribuutjes[:password_confirmation])
        # reset_password! calls "user.save"

        user
      end
    end
  end
end
