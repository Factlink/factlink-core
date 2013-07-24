module Queries
  module Opinions
    class RelevanceOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation, :pavlov_options

      private

      def execute
        fact_relation.get_user_opinion
      end
    end
  end
end
