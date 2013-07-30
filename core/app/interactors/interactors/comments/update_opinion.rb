require 'pavlov'

module Interactors
  module Comments
    class UpdateOpinion
      include Pavlov::Interactor

      arguments :comment_id, :opinion

      def execute
        if @opinion
          command :'comments/set_opinion', @comment_id, @opinion, pavlov_options[:current_user].graph_user
        else
          command :'comments/remove_opinion', @comment_id, pavlov_options[:current_user].graph_user
        end
        command :'opinions/recalculate_comment_user_opinion', comment

        comment
      end

      def comment
        @comment ||= query :'comments/get', @comment_id
      end

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_in_set :opinion, @opinion, ['believes', 'disbelieves', 'doubts', nil]
      end

      def authorized?
        pavlov_options[:current_user]
      end
    end
  end
end
