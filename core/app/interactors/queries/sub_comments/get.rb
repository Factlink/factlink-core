module Queries
  module SubComments
    class Get
      include Pavlov::Query
      arguments :id

      def validate
        validate_hexadecimal_string :id, @id
      end

      def execute
        KillObject.sub_comment sub_comment
      end

      def sub_comment
        SubComment.find(@id)
      end
    end
  end
end
