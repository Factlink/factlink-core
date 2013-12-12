module Queries
  module Users
    class FollowerCount
      include Pavlov::Query

      arguments :graph_user_id

      def execute
        user_following_users.followers_count
      end

      def user_following_users
        UserFollowingUsers.new(graph_user_id)
      end
    end
  end
end
