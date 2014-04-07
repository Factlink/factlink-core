module Backend
  module Comments
    extend self

    def by_ids(ids:, current_graph_user_id:)
      Comment.all_in(_id: Array(ids)).map do |comment|
        dead(comment: comment, current_graph_user_id: current_graph_user_id)
      end
    end

    def by_fact_id(fact_id:, current_graph_user_id:)
      fact_data_id = FactData.where(fact_id: fact_id).first.id
      Comment.where(fact_data_id: fact_data_id).map do |comment|
        dead(comment: comment, current_graph_user_id: current_graph_user_id)
      end
    end

    def remove_opinion(comment_id:, graph_user_id:)
      believable(comment_id).remove_opinionated_id graph_user_id
    end

    def set_opinion(comment_id:, graph_user_id:, opinion:)
      believable(comment_id).add_opiniated_id opinion, graph_user_id
    end

    def deletable?(comment_id)
      has_subcomments = SubComment.where(parent_id: comment_id).exists?
      !has_subcomments
    end

    def create(fact_id:, content:, user_id:)
      fact_data = FactData.where(fact_id: fact_id).first

      comment = Comment.new
      comment.fact_data_id = fact_data.id
      comment.created_by_id = user_id
      comment.content = content
      comment.save!

      comment
    end

    private

    def dead(comment:, current_graph_user_id:)
      current_user_opinion = current_user_opinion_for(comment_id: comment.id, current_graph_user_id: current_graph_user_id)

      DeadComment.new(
        id: comment.id,
        created_by: Backend::Users.by_ids(user_ids: comment.created_by_id).first,
        created_at: comment.created_at.utc.iso8601,
        formatted_content: FormattedCommentContent.new(comment.content).html,
        sub_comments_count: Backend::SubComments.count(parent_id: comment.id),
        is_deletable: Backend::Comments.deletable?(comment.id),
        tally: believable(comment.id).votes.merge(current_user_opinion: current_user_opinion)
      )
    end

    def current_user_opinion_for(comment_id:, current_graph_user_id:)
      return :no_vote unless current_graph_user_id

      believable(comment_id).opinion_of_graph_user_id current_graph_user_id
    end

    def believable(comment_id)
      ::Believable.new(Ohm::Key.new("Comment:#{comment_id}:believable"))
    end
  end
end
