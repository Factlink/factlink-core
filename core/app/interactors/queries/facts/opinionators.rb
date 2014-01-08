module Queries
  module Facts
    class Opinionators
      include Pavlov::Query

      arguments :fact_id, :type

      private

      def execute
        opinionator_ids = Fact[fact_id].opiniated(type).ids
        query :users_by_ids, user_ids: opinionator_ids, by: :graph_user_id
      end
    end
  end
end
