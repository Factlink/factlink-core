module Backend
  module Followers
    extend self

    def followers_for_fact fact
      comments = Comment.where(fact_data_id: fact.data_id)
      [
        direct_followers_for_fact(fact),
        followers_for_comments(comments),
      ].flatten.uniq
    end

    def followers_for_sub_comments sub_comments
      followers_for_comments(sub_comments.map(&:parent))
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
      comments_creators_ids = comments.map(&:created_by).map(&:graph_user_id)
      comments_opinionated_ids =
        comments.flat_map do |comment|
          Believable::Commentje.new(comment.id.to_s).opinionated_users_ids
        end
      comments_creators_ids + comments_opinionated_ids
    end

    def direct_followers_for_subcomments sub_comments
      sub_comments.map(&:created_by)
                  .map(&:id)
                  .map {|id| User.where(id: id).first.graph_user_id}
    end

    def direct_followers_for_fact fact
      fact.opinionated_users_ids
    end
  end
end
