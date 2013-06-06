require 'pavlov'
# TODO add specs
module Queries
  module Activities
    class GraphUserIdsFollowingComments
      include Pavlov::Query

      arguments :comments

      def execute
        follower_ids.uniq
      end

      def follower_ids
        comments_creators_ids +
          comments_opinionated_ids +
          sub_comments_on_comments_creators_ids
      end

      def comments_creators_ids
        comments.map {|comment| comment.created_by.graph_user_id}
      end

      def comments_opinionated_ids
        comments.flat_map {|comment| comment.believable.opinionated_users_ids}
      end

      def sub_comments_on_comments_creators_ids
        SubComment.where(parent_class: 'Comment').
                   any_in(parent_id: comments_ids.map(&:to_s)).
                   map(&:created_by).
                   map(&:graph_user_id)
      end

      def comments_ids
        comments.map(&:id)
      end

    end
  end
end
