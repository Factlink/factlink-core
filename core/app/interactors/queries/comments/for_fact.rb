module Queries
  module Comments
    class ForFact
      include Pavlov::Query

      arguments :fact_data_id

      private

      def execute
        query(:'comments/by_ids', ids: [fact_data_id], by: :fact_data_id)
      end
    end
  end
end
