module Interactors
  module Users
    class Following
      include Pavlov::Interactor

      arguments :user_name

      def authorized?
        !!pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :user_name, user_name
      end

      def execute
        query(:'users_by_ids', user_ids: graph_user_ids, by: :graph_user_id)
      end

      def graph_user_ids
        @graph_user_ids ||= begin
          user = query(:'user_by_username', username: user_name)

          query(:'users/following_graph_user_ids', graph_user_id: user.graph_user_id.to_s)
        end
      end
    end
  end
end
