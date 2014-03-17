module Interactors
  module Users
    class Following
      include Pavlov::Interactor

      arguments :username

      def authorized?
        !!pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :username, username
      end

      def execute
        query(:'dead_users_by_ids', user_ids: graph_user_ids, by: :graph_user_id)
      end

      def graph_user_ids
        @graph_user_ids ||= begin
          user = query(:'user_by_username', username: username)

          Backend::UserFollowers.get(graph_user_id: user.graph_user_id.to_s)
        end
      end
    end
  end
end
