require 'redis-aid'

class UserTopicsByAuthority
  include RedisUtils

  def initialize user_id, nest_key=Nest.new(:user)[:topics_by_authority]
    @user_id = user_id
    @key = nest_key
  end

  def set topic_id, authority
    @key[@user_id].zadd authority, topic_id
  end

  def ids_and_authorities_desc
    flat_array_to_hash zrevrange_with_scores 0, -1
  end

  def ids_and_authorities_desc_limit limit
    flat_array_to_hash zrevrange_with_scores 0, limit-1
  end

  private

  def zrevrange_with_scores start, stop
    @key[@user_id].zrevrange start, stop, withscores: true
  end

  def flat_array_to_hash flat_array
    array = hash_array_for_withscores flat_array

    array.map do |hash|
      {id: hash[:item], authority: hash[:score]}
    end
  end
end
