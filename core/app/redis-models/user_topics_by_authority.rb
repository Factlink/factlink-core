require 'redis-aid'

class UserTopicsByAuthority
  def initialize user_id, nest_key=Nest.new(:user)[:topics_by_authority]
    @user_id = user_id
    @key = nest_key
  end

  def set topic_id, authority
    @key[@user_id].zadd authority, topic_id
  end

  def ids_and_authorities_desc
    flat_array = @key[@user_id].zrevrange 0, -1, withscores: true
    array_of_pairs = flat_array.each_slice(2)

    array_of_pairs.map do |pair|
      {id: pair[0], authority: pair[1].to_f}
    end
  end
end
