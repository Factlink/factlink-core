class MapReduce
  class FactAuthority < MapReduce
    def all_set
      FactRelation.all
    end

    def map iterator
      iterator.ids.each do |fact_relation_id|
        fact_relation = FactRelation[fact_relation_id]
        yield fact_relation.from_fact_id, fact_relation.created_by_id
      end
    end

    def reduce fact_id, created_by_ids
      fact = Fact[fact_id]
      return nil unless fact

      authority_from_used_as_evidence(fact.created_by_id, created_by_ids) +
            authority_from_opiniated_users(fact)
    end

    def authority_from_used_as_evidence fact_creator_id, used_by_user_ids
      result = 0
      used_by_user_ids.each do |supporter_id|
        result += 1 unless supporter_id == fact_creator_id
      end
      [0, Math.log2(result)].max
    end

    def authority_from_opiniated_users fact
      fact.opinionated_users_count / 100
    end

    def write_output fact_id, authority
      fact = DeadFact.new fact_id

      Authority.from(fact) << authority
    end
  end
end
