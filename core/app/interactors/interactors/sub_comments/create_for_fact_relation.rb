require_relative '../../pavlov'

module Interactors
  module SubComments
    class CreateForFactRelation
      include Pavlov::Interactor

      arguments :fact_relation_id, :content

      def validate
        validate_integer :fact_relation_id, @fact_relation_id
        validate_regex   :content, @content, /\A.+\Z/,
          "should not be empty."
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        sub_comment = command :'sub_comments/create', @fact_relation_id, 'FactRelation', @content, @options[:current_user]
        KillObject.sub_comment sub_comment,
          authority: authority_of_user_who_created(sub_comment)
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
