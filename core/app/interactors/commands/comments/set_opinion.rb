module Commands
  module Comments
    class SetOpinion
      include Pavlov::Command

      arguments :comment_id, :opinion, :graph_user

      def execute
        believable.add_opiniated opinion, graph_user
      end

      def believable
        ::Believable::Commentje.new(comment_id)
      end
    end
  end
end
