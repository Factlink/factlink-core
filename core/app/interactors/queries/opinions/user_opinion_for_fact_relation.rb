module Queries
  module Opinions
    class UserOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        opinion = Opinion::BaseFactCalculation.new(fact_relation).get_user_opinion
        DeadOpinion.from_opinion opinion
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
