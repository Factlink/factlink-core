require 'pavlov'

module Interactors
  module Users
    class UnfollowUser
      include Pavlov::Interactor

      arguments :user_name, :user_to_unfollow_user_name

      def authorized?
        (!! @options[:current_user]) and (@options[:current_user].username == user_name)
      end

      def execute
        user = old_query :user_by_username, @user_name
        user_to_unfollow = old_query :user_by_username, @user_to_unfollow_user_name
        old_command :'users/unfollow_user', user.graph_user_id, user_to_unfollow.graph_user_id
        nil
      end

      def validate
        validate_nonempty_string :user_name, @user_name
        validate_nonempty_string :user_to_unfollow_user_name, @user_to_unfollow_user_name
      end
    end
  end
end
