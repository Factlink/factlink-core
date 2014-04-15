module Interactors
  module Users
    class Delete
      include Pavlov::Interactor
      include Util::CanCan

      attribute :username, String
      attribute :current_user_password, String
      attribute :pavlov_options

      def authorized?
        can? :destroy, Backend::Users.user_by_username(username: username)
      end

      private

      def validate
        validate_string :username, username
        fail Pavlov::ValidationError, 'current_user_password is invalid.' unless password_valid
      end

      def password_valid
        pavlov_options[:current_user].valid_password? current_user_password
      end

      def execute
        Backend::Users.delete username: username
      end
    end
  end
end
