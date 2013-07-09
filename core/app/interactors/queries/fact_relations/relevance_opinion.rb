module Queries
  module FactRelations
    class RelevanceOpinion
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        fact_relation.get_user_opinion
      end
    end
  end
end
