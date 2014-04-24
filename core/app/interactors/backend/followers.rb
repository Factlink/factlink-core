module Backend
  module Followers
    extend self

    def followers_for_fact_id fact_id
      comments = FactData.where(fact_id: fact_id).first.comments
      [
        direct_followers_for_fact(fact_id),
        followers_for_comments(comments),
      ].flatten.uniq
    end

    private

    def followers_for_comments comments
      comment_ids = comments.map(&:id).map(&:to_s)
      sub_comments = Backend::SubComments.index(parent_ids_in: comment_ids)
      [
        direct_followers_for_comments(comments),
        direct_followers_for_subcomments(sub_comments),
      ].flatten.uniq
    end

    def direct_followers_for_comments comments
      comments_creators_ids = comments.map(&:created_by).map(&:id)
      comments_opinionated_ids =
        comments.flat_map do |comment|
          CommentVote.where(comment_id: comment.id).map(&:user_id)
        end
      comments_creators_ids + comments_opinionated_ids
    end

    def direct_followers_for_subcomments sub_comments
      sub_comments.map(&:created_by)
                  .map(&:id)
    end

    def direct_followers_for_fact fact_id
      fact_data_id = FactData.where(fact_id: fact_id).first.id
      FactDataInteresting.where(fact_data_id: fact_data_id).map(&:user_id)
    end
  end
end
