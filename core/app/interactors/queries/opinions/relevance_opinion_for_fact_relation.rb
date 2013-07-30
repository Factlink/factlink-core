module Queries
  module Opinions
    class RelevanceOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation
      attribute :pavlov_options, Hash, default: {}

      private

      def execute
        FactGraph.new.user_opinion_for_fact_relation(fact_relation)
      end
    end
  end
end
