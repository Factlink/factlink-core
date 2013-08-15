module Interactors
  module Comments
    class Delete
      include Pavlov::Interactor

      arguments :comment_id

      def execute
        command(:'delete_comment',
                    comment_id: comment_id,
                    user_id: pavlov_options[:current_user].id.to_s)
      end

      def validate
        validate_hexadecimal_string :comment_id, comment_id
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
