module Backend
  module Comments
    extend self

    def by_ids(ids:, current_user_id:)
      Comment.where(id: ids).map do |comment|
        dead(comment: comment, current_user_id: current_user_id)
      end
    end

    def by_fact_id(fact_id:, current_user_id:)
      fact_data_id = FactData.where(fact_id: fact_id).first.id
      Comment.where(fact_data_id: fact_data_id).map do |comment|
        dead(comment: comment, current_user_id: current_user_id)
      end
    end

    def remove_opinion(comment_id:, user_id:)
      CommentVote.where(comment_id: comment_id, user_id: user_id)
                 .each {|comment_vote| comment_vote.destroy}
    end

    def set_opinion(comment_id:, user_id:, opinion:)
      remove_opinion(comment_id: comment_id, user_id: user_id)

      CommentVote.create! comment_id: comment_id, user_id: user_id, opinion: opinion
    end

    def deletable?(comment_id)
      has_subcomments = SubComment.where(parent_id: comment_id).exists?
      !has_subcomments
    end

    def opiniated(comment_id:, type:)
      Backend::Users.by_ids(user_ids: CommentVote.where(comment_id: comment_id, opinion: type).map(&:user_id))
    end

    def create(fact_id:, content:, user_id:, created_at:, markup_format:)
      fact_data = FactData.where(fact_id: fact_id.to_s).first

      comment = Comment.new
      comment.fact_data_id = fact_data.id.to_s
      comment.created_by_id = user_id
      comment.content = content
      comment.markup_format = markup_format
      comment.created_at = created_at
      comment.updated_at = created_at
      comment.save!

      comment
    end

    def update(comment_id:, content:, updated_at:)
      comment = Comment.find(comment_id)
      comment.content = content
      comment.updated_at = updated_at
      comment.save!

      nil
    end

    private

    def dead(comment:, current_user_id:)
      votes_counts = CommentVote.where(comment_id: comment.id).distinct.group(:opinion).count
      current_user_opinion = current_user_opinion_for(comment_id: comment.id, current_user_id: current_user_id)

      if comment.markup_format == 'anecdote'
        formatted_content = FormattedAnecdoteContent.new(comment.content).html
      else
        formatted_content = FormattedCommentContent.new(comment.content).html
      end

      DeadComment.new(
        id: comment.id.to_s,
        created_by: Backend::Users.by_ids(user_ids: comment.created_by_id).first,
        created_at: comment.created_at.utc.iso8601,
        content: comment.content,
        formatted_content: formatted_content,
        markup_format: comment.markup_format,
        sub_comments_count: Backend::SubComments.count(parent_id: comment.id),
        is_deletable: deletable?(comment.id),
        tally: {
          believes: votes_counts['believes'] || 0,
          disbelieves: votes_counts['disbelieves'] || 0,
          current_user_opinion: current_user_opinion,
        }
      )
    end

    def current_user_opinion_for(comment_id:, current_user_id:)
      return :no_vote unless current_user_id

      comment_vote = CommentVote.where(user_id: current_user_id, comment_id: comment_id).first
      return :no_vote if comment_vote.nil?

      comment_vote.opinion
    end
  end
end
