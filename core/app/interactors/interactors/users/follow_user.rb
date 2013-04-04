require 'pavlov'

module Interactors
  module Users
    class FollowUser
      include Pavlov::Interactor

      arguments :user_id, :user_to_follow_id

      def authorized?
        !! @options[:current_user]
      end

      def execute
        command :'users/follow_user', user_id, user_to_follow_id
        nil
      end

      def validate
        validate_hexadecimal_string :user_id, @user_id
        validate_hexadecimal_string :user_to_follow_id, @user_to_follow_id
      end
    end
  end
end
