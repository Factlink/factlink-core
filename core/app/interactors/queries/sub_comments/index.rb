module Queries
  module SubComments
    class Index
      include Pavlov::Query
      arguments :parent_ids_in, :parent_class

      def execute
        sub_comments.map(&method(:kill))
      end

      def kill sub_comment
        KillObject.sub_comment sub_comment
      end

      def sub_comments
        SubComment.where(parent_class: parent_class)
                  .any_in(parent_id: parent_ids)
                  .asc(:created_at)
      end

      def parent_ids
        ids = Array(parent_ids_in)
        if parent_class == 'FactRelation'
          ids.map(&:to_s)
        else
          ids
        end
      end
    end
  end
end
