module Interactors
  module SubComments
    class IndexForFactRelation
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_relation_id

      def validate
        validate_integer :fact_relation_id, fact_relation_id
      end

      def authorized?
        can? :show, fact_relation
      end

      def execute
        raise_error_if_non_existent

        query(:'sub_comments/index',
                  parent_ids_in: fact_relation_id, parent_class: 'FactRelation')
      end

      def raise_error_if_non_existent
        return if fact_relation

        raise Pavlov::ValidationError,
          "fact relation does not exist any more"
      end

      def fact_relation
        @fact_relation ||= FactRelation[fact_relation_id]
      end
    end
  end
end
