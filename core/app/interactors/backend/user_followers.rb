module Backend
  module UserFollowers
    extend self

    def followee_ids(follower_id:)
      UserFollowingUsers.new(follower_id).followee_ids
    end

    def following?(follower_id:, followee_id:)
      UserFollowingUsers.new(follower_id).follows? followee_id
    end

    def follow(follower_id:, followee_id:)
      UserFollowingUsers.new(follower_id).follow followee_id
    end

    def unfollow(follower_id:, followee_id:)
      UserFollowingUsers.new(follower_id).unfollow followee_id
    end
  end
end
