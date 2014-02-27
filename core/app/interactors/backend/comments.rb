module Backend
  module Comments
    extend self

    def remove_opinion(comment_id:, graph_user:)
      believable(comment_id).remove_opinionateds graph_user
    end

    def set_opinion(comment_id:, graph_user:, opinion:)
      believable(comment_id).add_opiniated opinion, graph_user
    end

    def deletable?(comment_id)
      has_subcomments = SubComment.where(parent_id: comment_id).exists?
      !has_subcomments
    end

    private

    def believable(comment_id)
      ::Believable::Commentje.new(comment_id)
    end

  end
end
