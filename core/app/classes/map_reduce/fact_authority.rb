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
        yield fr.from_fact_id, fr.created_by_id
      end
    end

    def reduce fact_id, created_by_ids
      f = Fact[fact_id]
      res = authority_from_used_as_evidence(f.created_by_id, created_by_ids)
#     res = res * 10 +  f.channels.count
    end

    def authority_from_used_as_evidence fact_creator_id, used_by_user_ids
      result = 0
      used_by_user_ids.each do |supporter_id|
        result += 1 unless supporter_id == fact_creator_id
      end
      res = [0, Math.log2(result)].max
    end

    def write_output fact_id, value
      authority = Authority.from(Fact[fact_id])
      authority << value
    end
  end
end
