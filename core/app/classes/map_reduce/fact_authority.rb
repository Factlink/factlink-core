class MapReduce
  class FactAuthority < MapReduce
    def all_set
      FactRelation.all
    end

    def set_for_one f
      FactRelation.all.find(from_fact_id: f.id)
    end

    def map iterator
      iterator.each do |fr|
        yield fr.fact_id, fr.created_by_id
      end
    end

    def reduce fact_id, created_by_ids
      result = 0
      fact_creator_id = Fact[fact_id].created_by_id
      created_by_ids.each do |supporter_id|
        results += 1 unless supporter_id != fact_creator_id
      end
      [1, result].max
    end
  end
end
