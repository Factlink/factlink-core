module Queries
  module Opinions
    class RelevanceOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        opinion = Opinion::BaseFactCalculation.new(fact_relation).get_user_opinion
        DeadOpinion.from_opinion opinion
      end
    end
  end
end
