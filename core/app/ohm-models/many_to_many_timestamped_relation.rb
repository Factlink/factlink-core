require_relative 'many_to_many_sorted_relation'

class ManyToManyTimestampedRelation < ManyToManySortedRelation
  def add_at_time(from_id, to_id, time)
    add from_id, to_id, time_to_score(time)
  end
  
  def replace_at_time(from_id, to_id, time)
    replace from_id, to_id, time_to_score(time)
  end

  def add_now(from_id, to_id)
    time = DateTime.now
    add from_id, to_id, time_to_score(time)
  end
  
  def replace_now(from_id, to_id)
    time = DateTime.now
    replace from_id, to_id, time_to_score(time)
  end

  def time_to_score(time)
    (time.to_time.to_f*1000).to_i
  end
end
