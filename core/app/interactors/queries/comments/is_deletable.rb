module Queries
  module Comments
    class IsDeletable
      include Pavlov::Query
      arguments :comment_id

      private

      def execute
        deletable
      end

      def comment
        @comment ||= Comment.find(comment_id)
      end

      def deletable
        EvidenceDeletable.new(comment, 'Comment', believable, graph_user_id_of_creator).deletable?
      end

      def believable
        ::Believable::Commentje.new(comment)
      end

      def graph_user_id_of_creator
        comment.created_by.graph_user_id
      end
    end
  end
end
