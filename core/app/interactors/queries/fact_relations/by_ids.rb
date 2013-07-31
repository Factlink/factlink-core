require 'pavlov'

module Queries
  module FactRelations
    class ByIds
      include Pavlov::Query

      arguments :fact_relation_ids

      private

      def validate
        fact_relation_ids.each do |fact_relation_id|
          validate_integer_string :fact_relation_id, fact_relation_id
        end
      end

      def execute
        fact_relation_ids.map do |fact_relation_id|
          fact_relation = FactRelation[fact_relation_id] or raise 'FactRelation could not be found'
          old_query :'fact_relations/add_sub_comments_count_and_opinions_and_evidence_class', fact_relation
        end
      end
    end
  end
end
