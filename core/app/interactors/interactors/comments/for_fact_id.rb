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
        query(:'comments/for_fact', fact_data_id: Fact[fact_id].data_id)
      end

      def relevance_of comment
        comment.votes[:believes] - comment.votes[:disbelieves]
      end
    end
  end
end
