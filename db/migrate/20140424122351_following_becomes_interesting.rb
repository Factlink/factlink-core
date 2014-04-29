class FollowingBecomesInteresting < ActiveRecord::Migration
  def up
    FactData.all.each do |fact_data|
      user_ids = followers_for_comments(fact_data.comments)

      user_ids.each do |user_id|
        Backend::Facts.set_interesting fact_id: fact_data.fact_id, user_id: user_id
      end
    end
  end

  def down
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
end
