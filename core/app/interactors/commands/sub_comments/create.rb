require_relative '../../pavlov'

module Commands
  module SubComments
    class Create
      include Pavlov::Command

      arguments :parent_id, :parent_class, :content, :user_id

      def execute
        sub_comment = SubComment.new
        sub_comment.parent_id = @parent_id.to_s
        sub_comment.parent_class = @parent_class
        sub_comment.created_by = creator
        sub_comment.content = @content
        sub_comment.save

        sub_comment
      end

      def creator
        User.find(@user_id)
      end

      def validate
        validate_hexadecimal_string :user_id, @user_id
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
