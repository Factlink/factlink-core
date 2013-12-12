module Queries
  module FactRelations
    class ByIds
      include Pavlov::Query

      arguments :fact_relation_ids

      private

      def execute
        fact_relation_ids.map do |fact_relation_id|
          fact_relation = FactRelation[fact_relation_id]

          unless fact_relation
            fail ActionController::RoutingError.new('FactRelation could not be found')
          end

          dead_fact_relation_for fact_relation
        end
      end

      def dead_fact_relation_for fact_relation
        fact_relation.sub_comments_count = query(:'sub_comments/count',
                                                    parent_id: fact_relation.id.to_s,
                                                    parent_class: fact_relation.class.to_s)

        KillObject.fact_relation fact_relation,
          votes: query(:'believable/votes', believable: fact_relation.believable),
          evidence_class: 'FactRelation'
      end
    end
  end
end
