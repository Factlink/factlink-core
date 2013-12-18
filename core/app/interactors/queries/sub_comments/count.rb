module Queries
  module SubComments
    class Count
      include Pavlov::Query
      arguments :parent_id, :parent_class

      def execute
        SubComment.where(parent_id: normalized_parent_id.to_s, parent_class: parent_class).count
      end

      def normalized_parent_id
        parent_class == 'FactRelation' ? parent_id.to_i : parent_id
      end
    end
  end
end
