require_relative '../../pavlov'

module Interactors
  module SubComments
    class CreateForComment
      include Pavlov::Interactor

      arguments :comment_id, :content

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_regex   :content, @content, /\A(?=\S).+\Z/,
          "should not be empty."
      end

      def authorized?
        @options[:current_user]
      end

      def execute
        sub_comment = command :'sub_comments/create_xxx', @comment_id, 'Comment', @content, @options[:current_user]

        create_activity sub_comment

        KillObject.sub_comment sub_comment,
          authority: authority_of_user_who_created(sub_comment)
      end

      def create_activity sub_comment
        command :create_activity,
          @options[:current_user].graph_user, :created_sub_comment,
          sub_comment, top_fact
      end

      def top_fact
        @top_fact ||= Comment.find(@comment_id).fact_data.fact
      end

      def authority_of_user_who_created sub_comment
        query :authority_on_fact_for, top_fact, sub_comment.created_by.graph_user
      end
    end
  end
end
