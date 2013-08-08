module Interactors
  module FactRelations
    class ById
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_relation_id

      private

      def authorized?
        can? :show, FactRelation
      end

      def validate
        validate_integer_string :fact_relation_id, fact_relation_id
      end

      def execute
        fact_relations.first
      end

      def fact_relations
        old_query :'fact_relations/by_ids', [fact_relation_id]
      end
    end
  end
end
