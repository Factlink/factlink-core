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

    def reduce bucket, partials
      result = 0
      partials.each do |i|
        if i != bucket.created_by
          results += 1
        end
      end
      [1, result].max
    end
  end
end
