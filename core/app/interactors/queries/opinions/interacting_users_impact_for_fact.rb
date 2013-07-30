module Queries
  module Opinions
    class InteractingUsersImpactForFact
      include Pavlov::Query

      arguments :fact_id, :type
      attribute :pavlov_options, Hash, default: {}

      def execute
        OpinionPresenter.new(user_opinion).authority(type)
      end

      def user_opinion
        FactGraph.new.user_opinion_for_fact(fact)
      end

      def fact
        Fact[fact_id]
      end
    end
  end
end

