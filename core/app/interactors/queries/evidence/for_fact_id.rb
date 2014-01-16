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
        []
      end

      def comments
        query(:'comments/for_fact', fact: fact)
      end

      def sort result
        result.sort do |a,b|
          relevance_of(b) <=> relevance_of(a)
        end
      end

      def relevance_of evidence
        evidence.votes[:believes] - evidence.votes[:disbelieves]
      end

      def fact
        @fact ||= Fact[fact_id]
      end
    end
  end
end
