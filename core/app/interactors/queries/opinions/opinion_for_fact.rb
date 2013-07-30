module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact
      attribute :pavlov_options, Hash, default: {}

      private

      def execute
        Opinion::FactCalculation.new(fact).get_opinion
      end
    end
  end
end
