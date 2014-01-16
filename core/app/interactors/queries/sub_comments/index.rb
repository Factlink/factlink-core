module Queries
  module SubComments
    class Index
      include Pavlov::Query
      arguments :parent_ids_in, :parent_class

      def execute
        sub_comments.map do |sub_comment|
          KillObject.sub_comment sub_comment
        end
      end

      def sub_comments
        SubComment.any_in(parent_id: parent_ids)
                  .asc(:created_at)
      end

      def parent_ids
        ids = Array(parent_ids_in)
      end
    end
  end
end
