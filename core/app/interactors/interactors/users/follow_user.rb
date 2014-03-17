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
          follower_id: current_user.graph_user_id,
          followee_id: user_to_follow.graph_user_id
      end

      def current_user
        @pavlov_options[:current_user]
      end

      def user_to_follow
        @user_to_follow ||= query(:'user_by_username', username: username)
      end

      def follow_user
        Backend::UserFollowers.follow \
          follower_id: current_user.graph_user_id,
          followee_id: user_to_follow.graph_user_id

        command(:'create_activity',
                    graph_user: current_user.graph_user, action: :followed_user,
                    subject: user_to_follow.graph_user, object: nil)


        Backend::Activities.add_activities_to_follower_stream(
          followed_user_graph_user_id: user_to_follow.graph_user_id,
          current_graph_user_id: current_user.graph_user_id)
      end


      def validate
        validate_nonempty_string :username, username
      end
    end
  end
end
