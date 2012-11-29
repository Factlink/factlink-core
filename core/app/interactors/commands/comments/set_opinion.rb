module Commands
  module Comments
    class SetOpinion
      include Pavlov::Command

      arguments :comment_id, :opinion_type, :graph_user

      def execute
        believable.add_opiniated @opinion_type, graph_user
      end

      def believable
        Believable::Comment.new(@comment_id)
      end

      def graph_user
       @graph_user
      end
    end
  end
end
