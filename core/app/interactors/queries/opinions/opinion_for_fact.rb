module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        fact.get_opinion
      end
    end
  end
end
