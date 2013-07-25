module Opinion
  class BaseFactCalculation

    attr_reader :base_fact

    def initialize(base_fact)
      @base_fact = base_fact
    end

    def get_user_opinion
      opinion_store.retrieve base_fact.class.name, base_fact.id, :user_opinion
    end

    def calculate_user_opinion
      user_opinion = real_calculate_user_opinion(base_fact)

      opinion_store.store base_fact.class.name, base_fact.id, :user_opinion, user_opinion
    end

    private

    def real_calculate_user_opinion(base_fact)
      UserOpinionCalculation.new(base_fact.believable) do |user|
        Authority.on(base_fact, for: user).to_f + 1.0
      end.opinion
    end

    def opinion_store
      Opinion::Store.new HashStore::Redis.new
    end
  end
end
