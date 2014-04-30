module Backend
  module UserFollowers
    extend self

    def followee_ids(follower_id:)
      Following.where(follower_id: follower_id).to_a.map(&:followee_id)
    end

    def follower_ids(followee_id:)
      Following.where(followee_id: followee_id).to_a.map(&:follower_id)
    end

    def following?(follower_id:, followee_id:)
      ! Following.where(follower_id: follower_id, followee_id: followee_id).empty?
    end

    def follow(follower_id:, followee_id:, time:)
      Following.create! \
        followee_id: followee_id,
        follower_id: follower_id,
        created_at: time,
        updated_at: time
    end

    def unfollow(follower_id:, followee_id:)
      Following.where(follower_id: follower_id, followee_id: followee_id)
               .map {|following| following.destroy }
    end
  end
end
