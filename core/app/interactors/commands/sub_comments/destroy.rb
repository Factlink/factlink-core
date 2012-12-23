module Commands
  module SubComments
    class Destroy
      include Pavlov::Command
      arguments :id
      def validate
        validate_hexadecimal_string :id, @id
      end

      def execute
        comment.delete
      end

      def comment
        SubComment.find(@id)
      end
    end
  end
end
