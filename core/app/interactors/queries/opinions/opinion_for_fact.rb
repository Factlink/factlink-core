module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        Opinion::FactCalculation.new(fact).get_opinion
      end
    end
  end
end
