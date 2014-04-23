module Interactors
  module Users
    class UnfollowUser
      include Pavlov::Interactor

      arguments :username

      def authorized?
        pavlov_options[:current_user]
      end

      def execute
        user_to_unfollow = Backend::Users.user_by_username(username: username)

        Backend::UserFollowers.unfollow \
          follower_id: current_user.id,
          followee_id: user_to_unfollow.id

        nil
      end

      def current_user
        @pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :username, username
      end
    end
  end
end
