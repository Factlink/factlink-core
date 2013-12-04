module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        fact.believable.dead_opinion
      end
    end
  end
end
