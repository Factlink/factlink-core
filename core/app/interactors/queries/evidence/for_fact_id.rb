module Queries
  module Evidence
    class ForFactId
      include Pavlov::Query

      arguments :fact_id

      private

      def execute
        sort(fact_relations + comments)
      end

      def fact_relations
        query(:'fact_relations/for_fact', fact: fact)
      end

      def comments
        query(:'comments/for_fact', fact: fact)
      end

      def sort result
        result.sort do |a,b|
          b.impact_opinion.authority <=> a.impact_opinion.authority
        end
      end

      def fact
        @fact ||= Fact[fact_id]
      end
    end
  end
end
