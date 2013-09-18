class DirectedRelationsSortedWithReverse
  attr_reader :relation_key
  attr_reader :reverse_relation_key

  def initialize nest_key
    @relation_key = nest_key[:relation]
    @reverse_relation_key = nest_key[:reverse_relation]
  end

  def add from_id, to_id, score
    return if has? from_id, to_id

    replace from_id, to_id, score
  end

  def replace from_id, to_id, score
    relation_key[from_id].zadd score, to_id
    reverse_relation_key[to_id].zadd score, from_id
  end

  def remove from_id, to_id
    relation_key[from_id].zrem to_id
    reverse_relation_key[to_id].zrem from_id
  end

  def ids from_id
    relation_key[from_id].zrange 0, -1
  end

  def reverse_ids to_id
    reverse_relation_key[to_id].zrange 0, -1
  end

  def has? from_id, to_id
    not relation_key[from_id].zrank(to_id).nil?
  end

  def count from_id
    relation_key[from_id].zcard
  end

  def reverse_count to_id
    reverse_relation_key[to_id].zcard
  end
end
