class MapReduce
  class FactRelationCredibility < MapReduce
    def all_set
      FactRelation.all
    end

    def authorities_on_fact_id(fact_id)
      @fact_authorities ||= {}
      @fact_authorities[fact_id] ||= Authority.all_on(Basefact[fact_id])
    end

    def map iterator
      iterator.ids.each do |fact_relation_id|
        # Warning: facts/_fact_relation.json.jbuilder depends on
        # that the fact relation credibility equals the to_fact credibility
        fact_relation = FactRelation[fact_relation_id]

        authorities_on_fact_id(fact_relation.fact_id).each do |a|
          yield({fact_id: fact_relation.id, user_id: a.user_id}, a.to_f)
        end
      end
    end

    def reduce bucket, authorities
      raise 'Only one authority per fact relation expected!' if authorities.size != 1

      authorities[0]
    end

    def write_output bucket, value
      f = FactRelation[bucket[:fact_id]] # TODO use dead fact relation
      gu = GraphUser[bucket[:user_id]] # TODO use dead graph user
      if f and gu
        Authority.on(f, for: gu) << value
      end
    end
  end
end
