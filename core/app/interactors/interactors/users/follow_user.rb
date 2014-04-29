module Interactors
  module Users
    class FollowUser
      include Pavlov::Interactor

      private

      arguments :username


      def authorized?
        pavlov_options[:current_user]
      end

      def execute
        if current_user.username == username
          raise "You cannot follow yourself."
        end

        return if already_following

        follow_user
      end

      def already_following
        Backend::UserFollowers.following? \
          follower_id: current_user.id,
          followee_id: user_to_follow.id
      end

      def current_user
        @pavlov_options[:current_user]
      end

      def user_to_follow
        @user_to_follow ||= Backend::Users.user_by_username(username: username)
      end

      def follow_user
        Backend::UserFollowers.follow \
          follower_id: current_user.id,
          followee_id: user_to_follow.id,
          time: pavlov_options[:time]

        Backend::Activities.create \
          user_id: current_user.id,
          action: :followed_user,
          subject: user_to_follow,
          time: pavlov_options[:time],
          send_mails: pavlov_options[:send_mails]
      end


      def validate
        validate_nonempty_string :username, username
      end
    end
  end
end
