module Interactors
  module Users
    class Following
      include Pavlov::Interactor

      arguments :user_name, :skip, :take

      def authorized?
        !!pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_integer :skip, skip
        validate_integer :take, take
      end

      def execute
        [paginated_users, graph_user_ids.length]
      end

      def paginated_users
        users = query(:'users_by_ids', user_ids: graph_user_ids.sort[skip, take], by: :graph_user_id)
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
