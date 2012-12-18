require_relative '../../pavlov'

module Commands
  module SubComments
    class Create
      include Pavlov::Command

      arguments :parent_id, :parent_class, :content, :user

      def execute
        sub_comment = SubComment.new
        sub_comment.parent_id = @parent_id.to_s
        sub_comment.parent_class = @parent_class
        sub_comment.created_by = @user
        sub_comment.content = @content
        sub_comment.save

        sub_comment
      end

      def validate
        validate_not_nil            :user, @user
        validate_regex              :content, @content, /\A.+\Z/,
          "should not be empty."
        validate_in_set             :parent_class, @parent_class,
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
