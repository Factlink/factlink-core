module Queries
  module Opinions
    class InteractingUsersImpactForFact
      include Pavlov::Query

      arguments :fact_id, :type

      def execute
        OpinionPresenter.new(user_opinion).authority(type)
      end

      def user_opinion
        opinion_store.retrieve :Fact, fact.id, :user_opinion
      end

      def opinion_store
        Opinion::Store.new HashStore::Redis.new
      end

      def fact
        Fact[fact_id]
      end
    end
  end
end

