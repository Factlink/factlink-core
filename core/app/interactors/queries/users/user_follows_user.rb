module Queries
  module Users
    class UserFollowsUser
      include Pavlov::Query

      attribute :from_graph_user_id, String
      attribute :to_graph_user_id, String

      def execute
        user_following_users.follows? to_graph_user_id
      end

      def user_following_users
        UserFollowingUsers.new(from_graph_user_id)
      end
    end
  end
end
