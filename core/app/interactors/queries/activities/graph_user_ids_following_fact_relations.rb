module Queries
  module Activities
    class GraphUserIdsFollowingFactRelations
      include Pavlov::Query

      arguments :fact_relations

      private

      def execute
        follower_ids.uniq
      end

      def follower_ids
        fact_relations_creators_ids +
          fact_relations_opinionated_ids +
          sub_comments_on_fact_relations_creators_ids
      end

      def fact_relations_creators_ids
        fact_relations.map(&:created_by_id)
      end

      def fact_relations_opinionated_ids
        fact_relations.flat_map(&:opinionated_users_ids)
      end

      def sub_comments_on_fact_relations_creators_ids
        sub_comments.map(&:created_by)
                    .map(&:graph_user_id)
      end

      def fact_relation_ids
        fact_relations.map(&:id)
      end

      def sub_comments
        query(:'sub_comments/index',
                  parent_ids_in: fact_relation_ids, parent_class: 'FactRelation')
      end
    end
  end
end
