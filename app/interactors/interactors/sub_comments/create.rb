module Interactors
  module SubComments
    class Create
      include Pavlov::Interactor
      include Util::CanCan

      arguments :comment_id, :content


      def authorized?
        can?(:show, comment) && can?(:create, SubComment)
      end

      def validate
        validate_hexadecimal_string :comment_id, comment_id
        validate_regex   :content, content, /\S/,
          "should not be empty."
      end

      def execute
        fail Pavlov::ValidationError, "parent does not exist any more" unless comment

        sub_comment = create_sub_comment

        create_activity sub_comment

        Backend::SubComments.dead_for sub_comment
      end

      def create_activity sub_comment
        Backend::Activities.create \
          user_id: pavlov_options[:current_user].id,
          action: :created_sub_comment,
          subject: sub_comment,
          time: pavlov_options[:time],
          send_mails: pavlov_options[:send_mails]
      end

      def create_sub_comment
        Backend::SubComments.create!(parent_id: comment_id,
                                     content: content,
                                     user: pavlov_options[:current_user],
                                     created_at: pavlov_options[:time])
      end

      def comment
        @comment ||= Comment.find(comment_id)
      end
    end
  end
end
