require 'pavlov'

module Commands
  module Users
    class UnfollowUser
      include Pavlov::Command

      arguments :user_id, :user_to_unfollow_id

      def execute
        user_following_users = UserFollowingUsers.new(user_id)
        user_following_users.unfollow user_to_unfollow_id
      end

      def validate
        validate_hexadecimal_string :user_id, user_id
        validate_hexadecimal_string :user_to_unfollow_id, user_to_unfollow_id
      end
    end
  end
end
