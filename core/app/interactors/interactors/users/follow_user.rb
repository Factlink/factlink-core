require 'pavlov'

module Interactors
  module Users
    class FollowUser
      include Pavlov::Interactor

      arguments :user_name, :user_to_follow_id

      def authorized?
        (!! @options[:current_user]) and (@options[:current_user].username == user_name)
      end

      def execute
        user = query :user_by_username, @user_name
        command :'users/follow_user', user.id, user_to_follow_id
        nil
      end

      def validate
        validate_nonempty_string :user_name, @user_name
        validate_hexadecimal_string :user_to_follow_id, @user_to_follow_id
      end
    end
  end
end
