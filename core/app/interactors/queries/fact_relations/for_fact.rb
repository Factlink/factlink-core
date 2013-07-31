require 'pavlov'

module Queries
  module FactRelations
    class ForFact
      include Pavlov::Query

      arguments :fact, :type

      def execute
        fact_relations.map do |fact_relation|
          old_query :'fact_relations/add_sub_comments_count_and_opinions_and_evidence_class', fact_relation
        end
      end

      def fact_relations
        fact.evidence(@type)
      end
    end
  end
end
