module Queries
  module Evidence
    class CountForFact
      include Pavlov::Query

      arguments :fact

      private

      def execute
        fact_relations_count + comments_count
      end

      def validate
        validate_not_nil :fact, fact
      end

      def fact_relations_count
        fact.evidence.size
      end

      def comments_count
        fact_data_id = fact.data_id
        Comment.where(fact_data_id: fact_data_id).count
      end
    end
  end
end
