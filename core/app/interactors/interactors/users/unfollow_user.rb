module Interactors
  module Users
    class UnfollowUser
      include Pavlov::Interactor

      arguments :username

      def authorized?
        pavlov_options[:current_user]
      end

      def execute
        user = pavlov_options[:current_user]
        user_to_unfollow = query(:'user_by_username',
                                    username: username)

        command(:'users/unfollow_user',
                    graph_user_id: user.graph_user_id,
                    user_to_unfollow_graph_user_id: user_to_unfollow.graph_user_id)
        nil
      end

      def validate
        validate_nonempty_string :username, username
      end
    end
  end
end
