module Commands
  module SubComments
    class Destroy
      include Pavlov::Command

      arguments :id

      def execute
        comment.delete
      end

      def comment
        SubComment.find(id)
      end
    end
  end
end
