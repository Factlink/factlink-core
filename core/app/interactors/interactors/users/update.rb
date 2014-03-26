module Interactors
  module Users
    class Update
      include Pavlov::Interactor
      include Util::CanCan

      private

      UPDATABLE_ATTRIBUTES = [:full_name, :username, :location, :biography,
                              :receives_mailed_notifications, :receives_digest]

      arguments :original_username, *UPDATABLE_ATTRIBUTES

      def execute
        new_attributes = attributes.slice(*UPDATABLE_ATTRIBUTES)
                                   .delete_if {|k, v| v.nil? }

        user.update_attributes! new_attributes

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
