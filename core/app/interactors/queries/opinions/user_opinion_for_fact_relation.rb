module Queries
  module Opinions
    class UserOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        FactGraph.new.user_opinion_for_fact_relation(fact_relation)
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
