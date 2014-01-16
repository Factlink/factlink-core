module Commands
  module SubComments
    class CreateXxx
      include Pavlov::Command

      arguments :parent_id, :content, :user

      def execute
        sub_comment = SubComment.new
        sub_comment.parent_id = parent_id.to_s
        sub_comment.parent_class = 'Comment'
        sub_comment.created_by = user
        sub_comment.content = content
        sub_comment.save!

        sub_comment
      end
    end
  end
end
