module Interactors
  module Comments
    class UpdateOpinion
      include Pavlov::Interactor

      arguments :comment_id, :opinion

      def execute
        if opinion == 'no_vote'
          Backend::Comments.remove_opinion \
            comment_id: comment_id,
            graph_user_id: pavlov_options[:current_user].graph_user_id
        else
          Backend::Comments.set_opinion \
            comment_id: comment_id,
            opinion: opinion,
            graph_user_id: pavlov_options[:current_user].graph_user_id
        end

        # TODO: why is there no current graph_user passed in here?
        Backend::Comments.by_ids(ids: comment_id, current_graph_user_id: nil).first
      end

      def validate
        validate_hexadecimal_string :comment_id, comment_id
        validate_in_set :opinion, opinion, ['believes', 'disbelieves', 'no_vote']
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
