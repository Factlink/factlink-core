class MapReduce
  class FactRelationCredibility < MapReduce
    def initialize
      @fact_authorities = {}
    end

    def all_set
      FactRelation.all
    end

    def authorities_on_fact_id(fact_id)
      @fact_authorities[fact_id] ||= Authority.all_on(Basefact[fact_id])
    end

    def map iterator
      iterator.each do |fact_relation|
        authorities_on_fact_id(fact_relation.fact_id).each do |a|
          yield({fact_relation: fact_relation, user_id: a.user_id}, a.to_f)
        end
      end
    end

    def reduce bucket, authorities
      if authorities.size != 1
        raise 'Only one authority per fact relation expected!'
      end
      authorities[0]
    end

    def write_output bucket, value
      gu = GraphUser[bucket[:user_id]]
      if gu
        Authority.on(fact_relation, for: gu) << value
      end
    end
  end
end
