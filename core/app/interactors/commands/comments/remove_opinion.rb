module Commands
  module Comments
    class RemoveOpinion
      include Pavlov::Command

      arguments :comment_id, :graph_user

      def execute
        believable.remove_opinionateds graph_user
      end

      def believable
        ::Believable::Commentje.new(comment_id)
      end
    end
  end
end
