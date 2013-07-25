module Opinion
  class FactCalculation

    attr_reader :fact

    def initialize(fact)
      @fact = fact
    end

    def get_evidence_opinion
      opinion_store.retrieve :Fact, fact.id, :evidence_opinion
    end

    def calculate_evidence_opinion
      opinions = fact.evidence(:both).map do |fr|
        FactRelationCalculation.new(fr).get_influencing_opinion
      end

      opinion_store.store :Fact, fact.id, :evidence_opinion, DeadOpinion.combine(opinions)
    end

    def get_opinion
      opinion_store.retrieve :Fact, fact.id, :opinion
    end

    def calculate_opinion
      opinion = BaseFactCalculation.new(fact).get_user_opinion + get_evidence_opinion

      opinion_store.store :Fact, fact.id, :opinion, opinion
    end

    private

    def opinion_store
      Opinion::Store.new HashStore::Redis.new
    end
  end
end
