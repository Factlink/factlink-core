require 'pavlov'

module Queries
  module FactRelations
    class ById
      include Pavlov::Query

      arguments :fact_relation_id

      private

      def validate
        validate_integer_string :fact_relation_id, fact_relation_id
      end

      def execute
        old_query :'fact_relations/add_sub_comments_count_and_opinions_and_evidence_class', fact_relation
      end

      def fact_relation
        FactRelation[fact_relation_id] or raise 'FactRelation could not be found'
      end
    end
  end
end
