require 'redis-aid'

class UserFollowingUsers

  attr_reader :user_id

  def initialize user_id, relation=ManyToManyTimestampedRelation.new(Nest.new(:user)[:following_users])
    @user_id = user_id
    @relation = relation
  end

  def follow other_id
    relation.add_now user_id, other_id
  end

  def unfollow other_id
    relation.remove user_id, other_id
  end

  def following_ids
    relation.ids user_id
  end

  def followers_ids
    relation.reverse_ids user_id
  end

  def follows? other_id
    relation.has? user_id, other_id
  end

  private
  def relation
    @relation
  end

end
