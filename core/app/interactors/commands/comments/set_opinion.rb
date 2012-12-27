module Commands
  module Comments
    class SetOpinion
      include Pavlov::Command

      arguments :comment_id, :opinion, :graph_user

      def validate
        validate_hexadecimal_string :comment_id, @comment_id
        validate_in_set             :opinion, @opinion, ['believes', 'disbelieves', 'doubts']
      end

      def execute
        believable.add_opiniated @opinion, graph_user
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
