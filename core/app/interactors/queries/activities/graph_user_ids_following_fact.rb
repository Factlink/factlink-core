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
        creator_ids +
          opinionated_users_ids +
          evidence_followers_ids
      end

      def creator_ids
        [fact.created_by_id]
      end

      def opinionated_users_ids
        fact.opinionated_users_ids
      end

      def evidence_followers_ids
        fact_relations_followers_ids + comments_followers_ids
      end

      def fact_relations_followers_ids
        query(:'activities/graph_user_ids_following_fact_relations',
                  fact_relations: fact_relations)
      end

      def fact_relations
        query(:'fact_relations/for_fact', fact: fact)
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
