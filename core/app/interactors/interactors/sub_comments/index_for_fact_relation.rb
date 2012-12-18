require_relative '../../pavlov'

module Interactors
  module SubComments
    class IndexForFactRelation
      include Pavlov::Interactor

      arguments :fact_relation_id

      def validate
        validate_integer :fact_relation_id, @fact_relation_id
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        result = query :'sub_comments/index', @fact_relation_id, 'FactRelation'

        result.map do |sub_comment|
          KillObject.sub_comment sub_comment,
            authority: authority_of_user_who_created(sub_comment)
        end
      end

      def top_fact
        @top_fact ||= FactRelation[@fact_relation_id].fact
      end

      def authority_of_user_who_created sub_comment
        query :authority_on_fact_for, top_fact, sub_comment.created_by.graph_user
      end
    end
  end
end
