module Backend
  module UserFollowers
    extend self

    def get(graph_user_id:)
      UserFollowingUsers.new(graph_user_id).following_ids
    end

    def following?(following_id:, followee_id:)
      UserFollowingUsers.new(following_id).follows? followee_id
    end
  end
end
