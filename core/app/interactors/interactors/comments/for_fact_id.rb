module Interactors
  module Comments
    class ForFactId
      include Pavlov::Interactor
      include Util::CanCan

      arguments :fact_id

      def authorized?
        can? :show, Fact
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
        if pavlov_options[:current_user]
          Backend::Comments.by_fact_id fact_id: fact_id,
            current_graph_user: pavlov_options[:current_user].graph_user
        else
          Backend::Comments.by_fact_id fact_id: fact_id
        end
      end

      def relevance_of comment
        comment.tally[:believes] - comment.tally[:disbelieves]
      end
    end
  end
end
