module Interactors
  module Users
    class ChangePassword
      include Pavlov::Interactor
      include Util::CanCan

      arguments :params

      def authorized?
        can? :update, user
      end

      private

      def execute
        attributes = params.slice(:current_password, :password, :password_confirmation)

        user.update_with_password(attributes) or fail('Could not update password')

        user
      end

      def user
        Backend::Users.user_by_username(username: params[:username])
      end
    end
  end
end
