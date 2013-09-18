class DirectedRelationsWithReverse
  attr_reader :relation_key
  attr_reader :reverse_relation_key

  def initialize nest_key
    @relation_key = nest_key[:relation]
    @reverse_relation_key = nest_key[:reverse_relation]
  end

  def add from_id, to_id
    relation_key[from_id].sadd to_id
    reverse_relation_key[to_id].sadd from_id
  end

  def remove from_id, to_id
    relation_key[from_id].srem to_id
    reverse_relation_key[to_id].srem from_id
  end

  def ids from_id
    relation_key[from_id].smembers
  end

  def reverse_ids to_id
    reverse_relation_key[to_id].smembers
  end

  def has? from_id, to_id
    relation_key[from_id].sismember to_id
  end

  def count from_id
    relation_key[from_id].scard
  end

  def reverse_count to_id
    reverse_relation_key[to_id].scard
  end
end
