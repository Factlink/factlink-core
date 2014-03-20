module Interactors
  module Users
    class Update
      include Pavlov::Interactor
      include Util::CanCan

      private

      arguments :original_username, :fields

      def execute
        user.update_attributes! fields

        {}
      end

      def user
        @user ||= Backend::Users.user_by_username(username: original_username) || fail('not found')
      end

      def authorized?
        can? :update, user
      end

      def validate
        validate_nonempty_string :original_username, original_username
      end
    end
  end
end
