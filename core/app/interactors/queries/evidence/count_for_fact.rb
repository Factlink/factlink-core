require 'pavlov'

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
        real_fact.evidence.size
      end

      def comments_count
        fact_data_id = real_fact.data_id
        Comment.where(fact_data_id: fact_data_id).size
      end

      def real_fact
        @real_fact ||= begin
          if fact.respond_to?(:evidence)
            fact
          else
            Fact[fact.id]
          end
        end
      end
    end
  end
end
