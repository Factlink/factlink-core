module Interactors
  module Users
    class Followers
      include Pavlov::Interactor

      arguments :user_name, :skip, :take

      def authorized?
        !!pavlov_options[:current_user]
      end

      private

      def validate
        validate_nonempty_string :user_name, user_name
        validate_integer :skip, skip
        validate_integer :take, take
      end

      def execute
        users = query(:'users_by_ids', user_ids: graph_user_ids, by: :graph_user_id)

        return users[skip, take],
               users.length,
               followed_by_me
      end

      def followed_by_me
        graph_user_ids.include? pavlov_options[:current_user].graph_user_id
      end

      def graph_user_ids
        @graph_user_ids ||= begin
          user = query(:'user_by_username', username: user_name)

          query(:'users/follower_graph_user_ids', graph_user_id: user.graph_user_id.to_s)
        end
      end
    end
  end
end
