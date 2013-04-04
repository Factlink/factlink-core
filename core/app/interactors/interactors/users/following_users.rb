require 'pavlov'

module Interactors
  module Users
    class FollowingUsers
      include Pavlov::Interactor

      arguments :user_id

      def authorized?
        !! @options[:current_user]
      end

      def validate
        validate_hexadecimal_string :user_id, @user_id
      end

      def execute
        query :'users/following_user_ids', @user_id
      end
    end
  end
end
