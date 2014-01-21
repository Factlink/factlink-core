module Interactors
  module SubComments
    class IndexForComment
      include Pavlov::Interactor
      include Util::CanCan

      arguments :comment_id

      def validate
        validate_hexadecimal_string :comment_id, comment_id
      end

      def authorized?
        can? :show, comment
      end

      def execute
        fail Pavlov::ValidationError, "comment does not exist any more" unless comment

        Backend::SubComments.index(parent_ids_in: comment_id)
      end

      def comment
        @comment ||= Comment.find(comment_id)
      end
    end
  end
end
