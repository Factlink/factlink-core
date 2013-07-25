module Opinion
  class FactRelationCalculation

    attr_reader :fact_relation

    def initialize(fact_relation)
      @fact_relation = fact_relation
    end

    def get_influencing_opinion
      opinion_store.retrieve :FactRelation, fact_relation.id, :influencing_opinion
    end

    def calculate_influencing_opinion
      from_fact_opinion = FactCalculation.new(fact_relation.from_fact).get_opinion
      user_opinion = BaseFactCalculation.new(fact_relation).get_user_opinion
      evidence_type = OpinionType.for_relation_type(fact_relation.type)

      influencing_opinion = real_calculate_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)

      opinion_store.store :FactRelation, fact_relation.id, :influencing_opinion, influencing_opinion
    end

    private

    def real_calculate_influencing_opinion(from_fact_opinion, user_opinion, evidence_type)
      net_fact_authority = from_fact_opinion.net_authority
      net_relevance_authority = user_opinion.net_authority
      authority = [[net_fact_authority, net_relevance_authority].min, 0].max

      DeadOpinion.for_type(evidence_type, authority)
    end

    def opinion_store
      Opinion::Store.new HashStore::Redis.new
    end
  end
end
