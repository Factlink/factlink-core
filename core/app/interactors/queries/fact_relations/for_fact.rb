module Queries
  module FactRelations
    class ForFact
      include Pavlov::Query

      arguments :fact

      def execute
        query(:'fact_relations/by_ids', fact_relation_ids: fact_relation_ids)
      end

      def fact_relation_ids
        FactRelation.find(fact_id: fact.id).ids
      end
    end
  end
end
