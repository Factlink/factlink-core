require 'pavlov'

module Queries
  module Comments
    class CanDestroy
      include Pavlov::Query
      arguments :comment_id, :user_id

      def execute
        created_by_user && deletable
      end

      def comment
        @comment ||= Comment.find(@comment_id)
      end

      def deletable
        EvidenceDeletable.new(comment, 'Comment', believable, graph_user_id_of_creator).deletable?
      end

      def believable
        Believable::Commentje.new(comment)
      end

      def graph_user_id_of_creator
        comment.created_by.graph_user_id
      end

      def created_by_user
        comment.created_by_id.to_s == @user_id
      end

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_hexadecimal_string :user_id, @user_id
      end
    end
  end
end
