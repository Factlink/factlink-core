require 'pavlov'

module Interactors
  module Comments
    class UpdateOpinion
      include Pavlov::Interactor

      arguments :comment_id, :opinion
      attribute :pavlov_options, Hash, default: {}

      def execute
        if opinion
          old_command 'comments/set_opinion', comment_id: comment_id,
            opinion: opinion, graph_user: pavlov_options[:current_user].graph_user
        else
          old_command 'comments/remove_opinion', comment_id: comment_id,
            graph_user: pavlov_options[:current_user].graph_user
        end
        old_query :'comments/get', comment_id
      end

      def validate
        validate_hexadecimal_string :comment_id, comment_id
        validate_in_set :opinion, opinion, ['believes', 'disbelieves', 'doubts', nil]
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
