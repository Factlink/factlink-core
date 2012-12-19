module Queries
  module SubComments
    class Count
      include Pavlov::Query
      arguments :parent_id, :parent_class

      def execute
        sub_comments = query :'sub_comments/index', normalized_parent_id, @parent_class
        sub_comments.length
      end

      def normalized_parent_id
        @parent_class == 'FactRelation' ? @parent_id.to_i : @parent_id
      end

      def validate
        validate_in_set               :parent_class, @parent_class,
          ['Comment','FactRelation']
        if @parent_class == 'FactRelation'
          validate_integer_string     :parent_id, @parent_id
        elsif @parent_class == 'Comment'
          validate_hexadecimal_string :parent_id, @parent_id
        else
          raise 'Trying to sub comment on a unrecognized parent class.'
        end
      end
    end
  end
end
