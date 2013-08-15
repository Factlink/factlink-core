module Interactors
  module Users
    class UnfollowUser
      include Pavlov::Interactor

      arguments :user_name, :user_to_unfollow_user_name

      def authorized?
        pavlov_options[:current_user] and (pavlov_options[:current_user].username == user_name)
      end

      def execute
        user = query(:'user_by_username', username: user_name)
        user_to_unfollow = query(:'user_by_username',
                                    username: user_to_unfollow_user_name)

        command(:'users/unfollow_user',
                    graph_user_id: user.graph_user_id,
                    user_to_unfollow_graph_user_id: user_to_unfollow.graph_user_id)
        nil
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_nonempty_string :user_to_unfollow_user_name, user_to_unfollow_user_name
      end
    end
  end
end
