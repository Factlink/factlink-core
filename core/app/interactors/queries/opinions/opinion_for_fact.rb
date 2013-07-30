module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact
      attribute :pavlov_options, Hash, default: {}

      private

      def execute
        FactGraph.new.opinion_for_fact(fact)
      end
    end
  end
end
