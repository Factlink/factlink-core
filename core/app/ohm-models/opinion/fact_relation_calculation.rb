class Opinion < OurOhm
  class FactRelationCalculation

    attr_reader :fact_relation

    def initialize(fact_relation)
      @fact_relation = fact_relation
    end

    def get_influencing_opinion
      fact_relation.influencing_opinion || Opinion.zero
    end

    def calculate_influencing_opinion
      net_fact_authority = FactCalculation.new(fact_relation.from_fact).get_opinion.net_authority
      net_relevance_authority = BaseFactCalculation.new(fact_relation).get_user_opinion.net_authority

      authority = [[net_fact_authority, net_relevance_authority].min, 0].max

      evidence_type = OpinionType.for_relation_type(fact_relation.type)
      influencing_opinion = Opinion.for_type(evidence_type, authority)

      fact_relation.set_opinion_of_type :influencing_opinion, influencing_opinion
    end

  end
end
