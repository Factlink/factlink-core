module Interactors
  module Users
    class FollowUser
      include Pavlov::Interactor

      private

      arguments :user_to_follow_username


      def authorized?
        (!!pavlov_options[:current_user])
      end

      def execute
        return if already_following

        follow_user
      end

      def already_following
        query(:'users/user_follows_user', from_graph_user_id: user.graph_user_id,
                                          to_graph_user_id: user_to_follow.graph_user_id)
      end

      def user
        @pavlov_options[:current_user]
      end

      def user_to_follow
        @user_to_follow ||= query(:'user_by_username', username: user_to_follow_username)
      end

      def follow_user
        command(:'users/follow_user',
                    graph_user_id: user.graph_user_id,
                    user_to_follow_graph_user_id: user_to_follow.graph_user_id)

        command(:'create_activity',
                    graph_user: user.graph_user, action: :followed_user,
                    subject: user_to_follow.graph_user, object: nil)

        # This command still depends on user == current_user
        command(:'stream/add_activities_of_user_to_stream',
                    graph_user_id: user_to_follow.graph_user_id)
      end


      def validate
        #validate_nonempty_string :username, username
        validate_nonempty_string :user_to_follow_username, user_to_follow_username

        if user.username == user_to_follow_username
          errors.add :user_to_follow_username, "You cannot follow yourself."
        end
      end
    end
  end
end
