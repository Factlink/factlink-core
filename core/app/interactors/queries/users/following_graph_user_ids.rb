require 'pavlov'

module Queries
  module Users
    class FollowingGraphUserIds
      include Pavlov::Query

      arguments :graph_user_id
      attribute :pavlov_options, Hash, default: {}

      def execute
        user_following_users = UserFollowingUsers.new(graph_user_id)
        user_following_users.following_ids
      end

      def validate
        validate_integer_string :graph_user_id, graph_user_id
      end
    end
  end
end
