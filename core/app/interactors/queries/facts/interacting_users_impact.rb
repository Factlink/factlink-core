module Queries
  module Facts
    class InteractingUsersImpact
      include Pavlov::Query

      arguments :fact_id, :type

      def execute
        OpinionPresenter.new(fact.get_user_opinion).authority(type)
      end

      def fact
        Fact[fact_id]
      end
    end
  end
end

