module Queries
  module Comments
    class Get
      include Pavlov::Query
      arguments :comment_id

      def execute
        query(:'comments/by_ids', by: :_id, ids: [comment_id]).first
      end
    end
  end
end
