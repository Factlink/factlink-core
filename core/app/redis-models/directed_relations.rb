class DirectedRelations
  attr_reader :relation_key

  def initialize nest_key
    @relation_key = nest_key[:relation]
  end

  def add from_id, to_id
    relation_key[from_id].sadd to_id
  end

  def remove from_id, to_id
    relation_key[from_id].srem to_id
  end

  def ids from_id
    relation_key[from_id].smembers
  end

  def has? from_id, to_id
    relation_key[from_id].sismember to_id
  end
end
