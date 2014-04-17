module Interactors
  module Comments
    class Create
      include Pavlov::Interactor

      arguments :fact_id, :content

      def execute
        comment = Backend::Comments.create \
          fact_id: fact_id,
          content: content,
          user_id: pavlov_options[:current_user].id.to_s,
          created_at: pavlov_options[:time]

        unless pavlov_options[:import]
          Backend::Comments.set_opinion \
            comment_id: comment.id.to_s, opinion: 'believes',
            graph_user_id: pavlov_options[:current_user].graph_user_id
        end

        create_activity comment

        Backend::Comments.by_ids(ids: comment.id,
          current_graph_user_id: pavlov_options[:current_user].graph_user_id).first
      end

      def create_activity comment
        Backend::Activities.create \
                    user_id: pavlov_options[:current_user].id,
                    action: :created_comment,
                    subject: comment,
                    time: pavlov_options[:time],
                    send_mails: pavlov_options[:send_mails]
      end

      def authorized?
        pavlov_options[:current_user]
      end

      def validate
        validate_regex   :content, content, /\S/,
          "should not be empty."
        validate_integer_string :fact_id, fact_id
      end
    end
  end
end
