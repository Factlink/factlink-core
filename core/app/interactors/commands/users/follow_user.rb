require 'pavlov'

module Commands
  module Users
    class FollowUser
      include Pavlov::Command

      arguments :graph_user_id, :user_to_follow_graph_user_id
      attribute :pavlov_options, Hash, default: {}

      def execute
        user_following_users.follow user_to_follow_graph_user_id
      end

      def user_following_users
        UserFollowingUsers.new(graph_user_id)
      end

      def validate
        validate_integer_string :graph_user_id, graph_user_id
        validate_integer_string :user_to_follow_graph_user_id, user_to_follow_graph_user_id
      end
    end
  end
end
