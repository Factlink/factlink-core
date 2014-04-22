module Interactors
  module Comments
    class ForFactId
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id

      def authorized?
        true
      end

      def validate
        validate_integer_string :fact_id, fact_id
      end

      def execute
        comments.sort do |a,b|
          relevance_of(b) <=> relevance_of(a)
        end
      end

      def comments
        Backend::Comments.by_fact_id fact_id: fact_id,
          current_user_id: current_user_id
      end

      def relevance_of comment
        comment.tally[:believes] - comment.tally[:disbelieves]
      end

      def current_user_id
        return nil unless pavlov_options[:current_user]

        pavlov_options[:current_user].id
      end
    end
  end
end
