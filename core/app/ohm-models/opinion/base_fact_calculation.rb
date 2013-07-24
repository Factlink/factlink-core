class Opinion < OurOhm
  class BaseFactCalculation

    attr_reader :base_fact

    def initialize(base_fact)
      @base_fact = base_fact
    end

    def get_user_opinion
      user_opinion_store.retrieve base_fact.class_name, base_fact.id, :user_opinion
    end

    def calculate_user_opinion
      user_opinion = UserOpinionCalculation.new(base_fact.believable) do |user|
        Authority.on(base_fact, for: user).to_f + 1.0
      end.opinion

      user_opinion_store.store base_fact.class_name, base_fact.id, :user_opinion, user_opinion
    end

    private

    def user_opinion_store
      Opinion::Store.new
    end
  end
end
