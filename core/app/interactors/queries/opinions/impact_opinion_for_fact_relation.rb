module Queries
  module Opinions
    class ImpactOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        evidence_type = OpinionType.for_relation_type(fact_relation.type)

        DeadOpinion.for_type(evidence_type, fact_relation.believable.dead_opinion.net_authority)
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
