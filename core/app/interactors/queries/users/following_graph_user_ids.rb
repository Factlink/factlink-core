module Queries
  module Users
    class FollowingGraphUserIds
      include Pavlov::Query

      arguments :graph_user_id

      def execute
        user_following_users = UserFollowingUsers.new(graph_user_id)
        user_following_users.following_ids
      end
    end
  end
end
