module Queries
  module Activities
    class GraphUserIdsFollowingFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        follower_ids.uniq
      end

      def follower_ids
        opinionated_users_ids +
          comments_followers_ids
      end

      def opinionated_users_ids
        fact.opinionated_users_ids
      end

      def comments_followers_ids
        query(:'activities/graph_user_ids_following_comments',
                  comments: comments)
      end

      def comments
        @comments ||= Comment.where(fact_data_id: fact.data_id)
      end
    end
  end
end
