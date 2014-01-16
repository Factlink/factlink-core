class Activity < OurOhm
  module Followers
    include Pavlov::Helpers

    def followers_for_fact fact
      query(:'activities/graph_user_ids_following_fact', fact: fact)
    end

    def followers_for_sub_comment sub_comment
      followers_for_comment sub_comment.parent
    end

    def followers_for_comment comment
      query(:'activities/graph_user_ids_following_comments', comments: [comment])
    end

    def followers_for_graph_user graph_user_id
      query(:'users/follower_graph_user_ids', graph_user_id: graph_user_id)
    end
  end
end
