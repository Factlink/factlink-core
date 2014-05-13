module Interactors
  module Comments
    class Update
      include Pavlov::Interactor

      arguments :comment_id, :content

      def execute
        Backend::Comments.update \
          comment_id: comment_id,
          content: content,
          updated_at: pavlov_options[:time]

        Backend::Comments.by_ids(ids: comment_id,
          current_user_id: pavlov_options[:current_user].id).first
      end

      def authorized?
        comment = Backend::Comments.by_ids(ids: comment_id,
          current_user_id: pavlov_options[:current_user].id).first

        comment.created_by.username == pavlov_options[:current_user].username
      end

      def validate
        validate_regex   :content, content, /\S/,
          "should not be empty."
        validate_integer_string :comment_id, comment_id
      end
    end
  end
end
