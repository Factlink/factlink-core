module Queries
  module Users
    class FollowingCount
      include Pavlov::Query

      arguments :graph_user_id

      def execute
        user_following_users.following_count
      end

      def user_following_users
        UserFollowingUsers.new(graph_user_id)
      end

      def validate
        validate_integer_string :graph_user_id, graph_user_id
      end
    end
  end
end
