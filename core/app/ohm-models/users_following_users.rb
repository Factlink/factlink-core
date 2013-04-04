require 'redis-aid'

class UsersFollowingUsers < ManyToManyRelation

  def initialize nest_key=Nest.new(:user)[:users_following_users]
    super nest_key
  end

  def follow id_from, id_to
    add id_from, id_to
  end

  def unfollow id_from, id_to
    remove id_from, id_to
  end

  def following id_from
    ids id_from
  end

  def followers id_to
    reverse_ids id_to
  end

  def follows? id_from, id_to
    has? id_from, id_to
  end

end
