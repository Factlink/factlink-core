module Queries
  module Opinions
    class UserOpinionForFactRelation
      include Pavlov::Query

      arguments :fact_relation

      private

      def execute
        opinion_store.retrieve :FactRelation, fact_relation.id, :user_opinion
      end

      def opinion_store
        Opinion::Store.new HashStore::Redis.new
      end

      def validate
        validate_not_nil :fact_relation, fact_relation
      end
    end
  end
end
