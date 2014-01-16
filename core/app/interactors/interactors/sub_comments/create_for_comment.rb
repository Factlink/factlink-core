module Interactors
  module SubComments
    class CreateForComment
      include Pavlov::Interactor

      arguments :comment_id, :content

      include Util::CanCan

      def authorized?
        can?(:show, parent) and
          can?(:create, SubComment)
      end

      def execute
        fail Pavlov::ValidationError, "parent does not exist any more" unless parent

        sub_comment = create_sub_comment

        create_activity sub_comment

        KillObject.sub_comment sub_comment
      end

      def create_activity sub_comment
        command(:'create_activity',
                    graph_user: pavlov_options[:current_user].graph_user,
                    action: :created_sub_comment, subject: sub_comment,
                    object: top_fact)
      end

      def validate
        validate_hexadecimal_string :comment_id, comment_id
        validate_regex   :content, content, /\S/,
          "should not be empty."
      end

      def parent
        comment
      end

      def create_sub_comment
        command(:'sub_comments/create_xxx',
                    parent_id: comment_id, parent_class: 'Comment',
                    content: content, user: pavlov_options[:current_user])
      end

      def top_fact
        @top_fact ||= comment.fact_data.fact
      end

      def comment
        @comment ||= Comment.find(comment_id)
      end
    end
  end
end
