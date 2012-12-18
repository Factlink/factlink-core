module Queries
  module SubComments
    class Index
      include Pavlov::Query
      arguments :parent_id, :parent_class

      def execute
        result = SubComment.find(parent_id: @parent_id.to_s, parent_class: @parent_class).asc(:created_at)
        result.map {|sub_comment| KillObject.sub_comment sub_comment }
      end

      def validate
        validate_in_set               :parent_class, @parent_class,
          ['Comment','FactRelation']
        if @parent_class == 'FactRelation'
          validate_integer            :parent_id, @parent_id
        elsif @parent_class == 'Comment'
          validate_hexadecimal_string :parent_id, @parent_id
        else
          raise 'Trying to sub comment on a unrecognized parent class.'
        end
      end
    end
  end
end
