class UserFollowingUsers
  attr_reader :graph_user_id, :relation, :following_key, :followers_key
  private :relation

  def initialize graph_user_id
    nest_key = Nest.new(:user)[:following_users]
    @following_key = nest_key[:relation]
    @followers_key = nest_key[:reverse_relation]

    @graph_user_id = graph_user_id
    @relation = relation
  end

  def follow other_id
    score = time_to_score(DateTime.now)

    following_key[graph_user_id].zadd score, other_id
    followers_key[other_id].zadd score, graph_user_id
  end

  def unfollow other_id
    following_key[graph_user_id].zrem other_id
    followers_key[other_id].zrem graph_user_id
  end

  def followee_ids
    following_key[graph_user_id].zrange 0, -1
  end

  def followers_ids
    followers_key[graph_user_id].zrange 0, -1
  end

  def follows? other_id
    not following_key[graph_user_id].zrank(other_id).nil?
  end

  def following_count
    following_key[graph_user_id].zcard
  end

  def followers_count
    followers_key[graph_user_id].zcard
  end

  private def time_to_score(time)
    (time.to_time.to_f*1000).to_i
  end
end
