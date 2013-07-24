module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        opinion = Opinion::FactCalculation.new(fact).get_opinion
        DeadOpinion.from_opinion opinion
      end
    end
  end
end
