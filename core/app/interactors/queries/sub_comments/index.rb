module Queries
  module SubComments
    class Index
      include Pavlov::Query
      arguments :parent_id, :parent_class

      def execute
        @parent_id = Array(parent_id)

        sub_comments.asc(:created_at)
          .map {|sub_comment| KillObject.sub_comment sub_comment }
      end

      def sub_comments
        SubComment.where(parent_class: parent_class)
                  .any_in(parent_id: parent_id)
      end

      def validate_id id, index
        if parent_class == 'FactRelation'
          validate_integer "parent_id[#{index}]", id
        elsif parent_class == 'Comment'
          validate_hexadecimal_string "parent_id[#{index}]", id
        end
      end

      def validate
        @parent_id = Array(parent_id)

        validate_in_set :parent_class, parent_class, ['Comment','FactRelation']

        parent_id.each_with_index do |id, index|
          validate_id id, index
        end
      end
    end
  end
end
