module Interactors
  module Comments
    class UpdateOpinion
      include Pavlov::Interactor

      arguments :comment_id, :opinion

      def execute
        if opinion == 'no_vote'
          Backend::Comments.remove_opinion \
            comment_id: comment_id,
            user_id: pavlov_options[:current_user].id
        else
          Backend::Comments.set_opinion \
            comment_id: comment_id,
            opinion: opinion,
            user_id: pavlov_options[:current_user].id
        end

        # TODO: why is there no current user passed in here?
        Backend::Comments.by_ids(ids: comment_id, current_user_id: nil).first
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
