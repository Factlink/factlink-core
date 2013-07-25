module Queries
  module SubComments
    class Index
      include Pavlov::Query
      arguments :parent_ids_in, :parent_class
      attribute :pavlov_options, Hash, default: {}

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

      def validate_id id, index
        if parent_class == 'FactRelation'
          validate_integer_string "parent_id[#{index}]", id
        elsif parent_class == 'Comment'
          validate_hexadecimal_string "parent_id[#{index}]", id
        end
      end

      def parent_ids
        ids = Array(parent_ids_in)
        if parent_class == 'FactRelation'
          ids.map(&:to_s)
        else
          ids
        end
      end

      def validate
        validate_in_set :parent_class, parent_class, ['Comment','FactRelation']

        parent_ids.each_with_index do |id, index|
          validate_id id, index
        end
      end
    end
  end
end
