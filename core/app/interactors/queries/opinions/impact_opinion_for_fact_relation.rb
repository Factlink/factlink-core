module Queries
  module Opinions
    class ImpactOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        FactGraph.new.impact_opinion_for_fact_relation(fact_relation, allow_negative_authority: true)
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
