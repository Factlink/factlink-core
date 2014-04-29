module Interactors
  module Comments
    class Delete
      include Pavlov::Interactor
      include Util::CanCan

      arguments :comment_id

      def execute
        comment.destroy
      end

      def comment
        @comment ||= Comment.find(comment_id)
      end

      def validate
        validate_hexadecimal_string :comment_id, comment_id
      end

      def authorized?
        can? :destroy, comment
      end
    end
  end
end
