module Interactors
  module Users
    class Delete
      include Pavlov::Interactor
      include Util::CanCan

      arguments :user_id

      private

      def authorized?
        can? :delete, user
      end

      def user
        @user ||= User.find user_id
      end

      def validate
        validate_hexadecimal_string :user_id, user_id
      end

      def execute
        command :'users/mark_as_deleted', user: user
        command :'users/anonymize_user_model', user_id: user_id
      end
    end
  end
end
