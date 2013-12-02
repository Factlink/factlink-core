module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        FactGraph.new.user_opinion_for_fact(fact)
      end
    end
  end
end
