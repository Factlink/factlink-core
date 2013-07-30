require 'pavlov'

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

        sub_comments.map(&method(:kill))
      end

      def kill sub_comment
        KillObject.sub_comment sub_comment,
          authority: authority_of_user_who_created(sub_comment)
      end

      def sub_comments
        old_query :'sub_comments/index', fact_relation_id, 'FactRelation'
      end

      def raise_error_if_non_existent
        return if fact_relation

        raise Pavlov::ValidationError,
          "fact relation does not exist any more"
      end

      def top_fact
        @top_fact ||= fact_relation.fact
      end

      def fact_relation
        @fact_relation ||= FactRelation[fact_relation_id]
      end

      def authority_of_user_who_created sub_comment
        old_query :authority_on_fact_for, top_fact, sub_comment.created_by.graph_user
      end
    end
  end
end
