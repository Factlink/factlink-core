module Interactors
  module Comments
    class Create
      include Pavlov::Interactor

      arguments :fact_id, :content

      def execute
        comment = Backend::Comments.create \
          fact_id: fact_id,
          content: content,
          user_id: pavlov_options[:current_user].id.to_s

        Backend::Comments.set_opinion \
          comment_id: comment.id.to_s, opinion: 'believes',
          graph_user: pavlov_options[:current_user].graph_user

        create_activity comment

        Backend::Comments.by_ids(ids: comment.id,
          current_graph_user: pavlov_options[:current_user].graph_user).first
      end

      def create_activity comment
        Backend::Activities.create \
                    graph_user: pavlov_options[:current_user].graph_user,
                    action: :created_comment,
                    subject: comment,
                    object: comment.fact_data.fact
      end

      def authorized?
        pavlov_options[:current_user]
      end

      def validate
        validate_regex   :content, content, /\S/,
          "should not be empty."
        validate_integer :fact_id, fact_id
      end
    end
  end
end
