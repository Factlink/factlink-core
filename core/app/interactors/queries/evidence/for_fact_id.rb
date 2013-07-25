require 'pavlov'

module Queries
  module Evidence
    class ForFactId
      include Pavlov::Query

      arguments :fact_id, :type
      attribute :pavlov_options, Hash, default: {}

      private

      def validate
        validate_integer_string :fact_id, fact_id
        validate_in_set         :type,    type, [:weakening, :supporting]
      end

      def execute
        sort(fact_relations + comments)
      end

      def fact_relations
        old_query :'fact_relations/for_fact', fact, type
      end

      def comments
        old_query :'comments/for_fact', fact, type
      end

      def sort result
        result.sort do |a,b|
          OpinionPresenter.new(b.opinion).relevance <=>
            OpinionPresenter.new(a.opinion).relevance
        end
      end

      def fact
        @fact ||= Fact[fact_id]
      end
    end
  end
end
