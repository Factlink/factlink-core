module Queries
  module FactRelations
    class ForFact
      include Pavlov::Query

      arguments :fact, :type

      def execute
        old_query :'fact_relations/by_ids', fact_relation_ids
      end

      def fact_relation_ids
        fact.evidence(@type).ids
      end
    end
  end
end
