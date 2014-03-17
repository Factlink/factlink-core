module Backend
  module UserFollowers
    extend self

    def get(graph_user_id:)
      UserFollowingUsers.new(graph_user_id).following_ids
    end
  end
end
