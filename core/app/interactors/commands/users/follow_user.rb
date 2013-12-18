module Commands
  module Users
    class FollowUser
      include Pavlov::Command

      arguments :graph_user_id, :user_to_follow_graph_user_id

      def execute
        user_following_users.follow user_to_follow_graph_user_id
      end

      def user_following_users
        UserFollowingUsers.new(graph_user_id)
      end
    end
  end
end
