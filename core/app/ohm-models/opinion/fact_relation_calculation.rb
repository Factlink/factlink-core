module Opinion
  class FactRelationCalculation

    attr_reader :fact_relation

    def initialize(fact_relation)
      @fact_relation = fact_relation
    end

    def get_influencing_opinion
      opinion_store.store :FactRelation, fact_relation.id, :influencing_opinion
    end

    def calculate_influencing_opinion
      net_fact_authority = FactCalculation.new(fact_relation.from_fact).get_opinion.net_authority
      net_relevance_authority = BaseFactCalculation.new(fact_relation).get_user_opinion.net_authority

      authority = [[net_fact_authority, net_relevance_authority].min, 0].max

      evidence_type = OpinionType.for_relation_type(fact_relation.type)
      influencing_opinion = DeadOpinion.for_type(evidence_type, authority)

      opinion_store.store :FactRelation, fact_relation.id, :influencing_opinion, influencing_opinion
    end

    private

    def opinion_store
      Opinion::Store.new
    end
  end
end
