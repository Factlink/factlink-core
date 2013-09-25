module Interactors
  module Users
    class Delete
      include Pavlov::Interactor
      include Util::CanCan

      attribute :user_id, String
      attribute :current_user_password, String

      def authorized?
        can? :delete, user
      end

      private

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
