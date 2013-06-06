require 'pavlov'
module Queries
  module Activities
    class GraphUserIdsFollowingFactRelations
      include Pavlov::Query

      arguments :fact_relations

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
        SubComment.where(parent_class: 'FactRelation').
                   any_in(parent_id: fact_relations_ids.map(&:to_s)).
                   map(&:created_by).
                   map(&:graph_user_id)
      end

      def fact_relations_ids
        fact_relations.map(&:id)
      end

    end
  end
end
