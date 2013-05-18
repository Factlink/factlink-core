require_relative 'directed_relations_sorted_with_reverse'

class DirectedRelationsTimestampedWithReverse < DirectedRelationsSortedWithReverse
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
