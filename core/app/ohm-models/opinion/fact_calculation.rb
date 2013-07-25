module Opinion
  class FactCalculation

    attr_reader :fact

    def initialize(fact)
      @fact = fact
    end

    def calculate_opinion
      user_opinion = BaseFactCalculation.new(fact).get_user_opinion
      evidence_opinion = opinion_store.retrieve :Fact, fact.id, :evidence_opinion

      opinion = real_calculate_opinion(user_opinion, evidence_opinion)

      opinion_store.store :Fact, fact.id, :opinion, opinion
    end

    private

    def real_calculate_opinion(user_opinion, evidence_opinion)
      user_opinion + evidence_opinion
    end

    def opinion_store
      Opinion::Store.new HashStore::Redis.new
    end
  end
end
