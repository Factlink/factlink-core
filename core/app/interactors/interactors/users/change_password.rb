module Interactors
  module Users
    class ChangePassword
      include Pavlov::Interactor
      include Util::CanCan

      arguments :params

      def authorized?
        can? :update, current_user
      end

      private

      def execute
        attributes = {
          current_password: params[:current_password],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        }

        current_user.update_with_password(attributes) or fail('Could not update password')

        {}
      end

      def current_user
        pavlov_options[:current_user]
      end
    end
  end
end
