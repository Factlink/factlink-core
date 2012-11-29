require_relative '../../pavlov'

module Interactors
  module Comments
    class SetOpinion
      include Pavlov::Interactor

      arguments :comment_id, :opinion

      def execute

      end

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_in_set :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
      end

      def authorized?
        @options[:current_user]
      end
    end
  end
end
