module Queries
  module Opinions
    class OpinionForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        opinion_store.retrieve :Fact, fact.id, :opinion
      end

      def opinion_store
        Opinion::Store.new HashStore::Redis.new
      end
    end
  end
end
