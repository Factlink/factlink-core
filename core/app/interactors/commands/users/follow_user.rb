require 'pavlov'

module Commands
  module Users
    class FollowUser
      include Pavlov::Command

      arguments :user_id, :user_to_follow_id

      def execute
        user_following_users = UserFollowingUsers.new(user_id)
        user_following_users.follow user_to_follow_id
      end

      def validate
        validate_hexadecimal_string :user_id, user_id
        validate_hexadecimal_string :user_to_follow_id, user_to_follow_id
      end
    end
  end
end
