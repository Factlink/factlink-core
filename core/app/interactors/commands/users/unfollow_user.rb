module Commands
  module Users
    class UnfollowUser
      include Pavlov::Command

      arguments :graph_user_id, :user_to_unfollow_graph_user_id

      private

      def execute
        user_following_users.unfollow user_to_unfollow_graph_user_id
      end

      def user_following_users
        UserFollowingUsers.new(graph_user_id)
      end
    end
  end
end
