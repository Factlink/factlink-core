module Queries
  module Opinions
    class RelevanceOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        Opinion::BaseFactCalculation.new(fact_relation).get_user_opinion
      end
    end
  end
end
