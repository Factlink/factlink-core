require 'pavlov'

module Queries
  module Evidence
    class CountForFactId
      include Pavlov::Query

      arguments :fact_id

      private

      def execute
        fact_relations_count + comments_count
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end

      def fact_relations_count
        fact.evidence.size
      end

      def comments_count
        fact_data_id = fact.data_id
        Comment.where(fact_data_id: fact_data_id).size
      end

      def fact
        @fact ||= Fact[fact_id]
      end
    end
  end
end
