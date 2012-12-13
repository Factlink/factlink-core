require_relative '../../pavlov'

module Commands
  module Comments
    class RemoveOpinion
      include Pavlov::Command

      arguments :comment_id, :graph_user

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
      end

      def execute
        believable.remove_opinionateds graph_user
      end

      def believable
        Believable::Commentje.new(@comment_id)
      end

      def graph_user
       @graph_user
      end
    end
  end
end
