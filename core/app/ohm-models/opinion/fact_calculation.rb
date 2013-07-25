module Opinion
  class FactCalculation

    attr_reader :fact

    def initialize(fact)
      @fact = fact
    end

    def calculate_evidence_opinion
      opinion_store.store :Fact, fact.id, :evidence_opinion, real_calculate_evidence_opinion(fact)
    end

    def get_opinion
      opinion_store.retrieve :Fact, fact.id, :opinion
    end

    def calculate_opinion
      user_opinion = BaseFactCalculation.new(fact).get_user_opinion
      evidence_opinion = opinion_store.retrieve :Fact, fact.id, :evidence_opinion

      opinion = real_calculate_opinion(user_opinion, evidence_opinion)

      opinion_store.store :Fact, fact.id, :opinion, opinion
    end

    private

    def real_calculate_evidence_opinion(fact)
      opinions = fact.evidence(:both).map do |fr|
        FactRelationCalculation.new(fr).get_influencing_opinion
      end

      DeadOpinion.combine(opinions)
    end

    def real_calculate_opinion(user_opinion, evidence_opinion)
      user_opinion + evidence_opinion
    end

    def opinion_store
      Opinion::Store.new HashStore::Redis.new
    end
  end
end
