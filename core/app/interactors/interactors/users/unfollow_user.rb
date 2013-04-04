require 'pavlov'

module Interactors
  module Users
    class UnfollowUser
      include Pavlov::Interactor

      arguments :user_name, :user_to_unfollow_id

      def authorized?
        !! @options[:current_user]
      end

      def execute
        user = query :user_by_username, @user_name
        command :'users/unfollow_user', user.id, user_to_unfollow_id
        nil
      end

      def validate
        validate_nonempty_string :user_name, @user_name
        validate_hexadecimal_string :user_to_unfollow_id, @user_to_unfollow_id
      end
    end
  end
end
