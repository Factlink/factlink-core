class UserFollowingUsers

  attr_reader :graph_user_id, :relation
  private :relation

  def initialize graph_user_id, relation=DirectedRelationsTimestampedWithReverse.new(Nest.new(:user)[:following_users])
    @graph_user_id = graph_user_id
    @relation = relation
  end

  def follow other_id
    relation.add_now graph_user_id, other_id
  end

  def unfollow other_id
    relation.remove graph_user_id, other_id
  end

  def following_ids
    relation.ids graph_user_id
  end

  def followers_ids
    relation.reverse_ids graph_user_id
  end

  def follows? other_id
    relation.has? graph_user_id, other_id
  end

  def following_count
    relation.count graph_user_id
  end

  def followers_count
    relation.reverse_count graph_user_id
  end
end
