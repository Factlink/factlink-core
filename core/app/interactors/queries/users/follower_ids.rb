require 'pavlov'

module Queries
  module Users
    class FollowerIds
      include Pavlov::Query

      arguments :user_id

      def execute
        user_following_users = UserFollowingUsers.new(user_id)
        user_following_users.followers_ids
      end

      def validate
        validate_hexadecimal_string :user_id, user_id
      end
    end
  end
end
