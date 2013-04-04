require 'pavlov'

module Interactors
  module Users
    class UnfollowUser
      include Pavlov::Interactor

      arguments :user_id, :user_to_unfollow_id

      def authorized?
        !! @options[:current_user]
      end

      def execute
        command :'users/unfollow_user', user_id, user_to_unfollow_id
      end

      def validate
        validate_hexadecimal_string :user_id, @user_id
        validate_hexadecimal_string :user_to_unfollow_id, @user_to_unfollow_id
      end
    end
  end
end
