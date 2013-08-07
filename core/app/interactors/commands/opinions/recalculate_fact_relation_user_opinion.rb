module Commands
  module Opinions
    class RecalculateFactRelationUserOpinion
      include Pavlov::Command

      arguments :fact_relation

      def execute
        FactGraph.new.calculate_fact_relation_when_user_opinion_changed fact_relation
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
