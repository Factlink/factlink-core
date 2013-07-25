module Queries
  module Opinions
    class RelevanceOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        opinion_store.retrieve :FactRelation, fact_relation.id, :user_opinion
      end

      def opinion_store
        Opinion::Store.new HashStore::Redis.new
      end
    end
  end
end
