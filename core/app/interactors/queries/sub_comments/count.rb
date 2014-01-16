module Queries
  module SubComments
    class Count
      include Pavlov::Query
      arguments :parent_id

      def execute
        SubComment.where(parent_id: parent_id.to_s).count
      end
    end
  end
end
