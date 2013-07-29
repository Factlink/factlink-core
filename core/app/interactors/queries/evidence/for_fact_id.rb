require 'pavlov'

module Queries
  module Evidence
    class ForFactId
      include Pavlov::Query

      arguments :fact_id, :type

      private

      def validate
        validate_integer_string :fact_id, @fact_id
        validate_in_set         :type,    @type, [:weakening, :supporting]
      end

      def execute
        sort(fact_relations + comments)
      end

      def fact_relations
        query :'fact_relations/for_fact', fact, type
      end

      def comments
        query :'comments/for_fact', fact, type
      end

      def sort result
        result.sort do |a,b|
          OpinionPresenter.new(b.impact_opinion).impact <=> OpinionPresenter.new(a.impact_opinion).impact
        end
      end

      def fact
        @fact ||= Fact[@fact_id]
      end
    end
  end
end
