require 'pavlov'

module Interactors
  module Users
    class FollowUser
      include Pavlov::Interactor

      arguments :user_name, :user_to_follow_user_name

      def authorized?
        (!! pavlov_options[:current_user]) and (pavlov_options[:current_user].username == user_name)
      end

      def execute
        user = old_query :user_by_username, user_name

        unless user.id.to_s == pavlov_options[:current_user].id.to_s
          throw "Only supporting user == current_user when following user"
        end

        user_to_follow = old_query :user_by_username, user_to_follow_user_name
        old_command :'users/follow_user', user.graph_user_id, user_to_follow.graph_user_id
        old_command :'create_activity', user.graph_user, :followed_user, user_to_follow.graph_user, nil

        # This command still depends on user == current_user
        old_command :'stream/add_activities_of_user_to_stream', user_to_follow.graph_user_id

        nil
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_nonempty_string :user_to_follow_user_name, user_to_follow_user_name

        if user_name == user_to_follow_user_name
          raise Pavlov::ValidationError, "You cannot follow yourself."
        end
      end
    end
  end
end
