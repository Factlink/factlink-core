module Backend
  module Followers
    extend self

    def followers_for_fact_id fact_id
      comments = FactData.where(fact_id: fact_id).first.comments
      [
        direct_followers_for_fact(fact_id).map { |id| User.find(id).graph_user_id },
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
          believable = ::Believable.new(Ohm::Key.new("Comment:#{comment.id}:believable"))
          believable.opinionated_users_ids.map {|id| User.where(id: id).first.graph_user_id }
        end
      comments_creators_ids + comments_opinionated_ids
    end

    def direct_followers_for_subcomments sub_comments
      sub_comments.map(&:created_by)
                  .map(&:id)
                  .map {|id| User.where(id: id).first.graph_user_id}
    end

    def direct_followers_for_fact fact_id
      Believable.new(Ohm::Key.new('Fact')[fact_id]).opinionated_users_ids
    end
  end
end
