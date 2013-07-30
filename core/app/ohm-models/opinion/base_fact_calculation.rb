class Opinion < OurOhm
  class BaseFactCalculation

    attr_reader :base_fact

    def initialize(base_fact)
      @base_fact = base_fact
    end

    def get_user_opinion
      base_fact.get_dead_opinion :user_opinion
    end

    def calculate_user_opinion
      user_opinion = UserOpinionCalculation.new(base_fact.believable) do |user|
        Authority.on(base_fact, for: user).to_f + 1.0
      end.opinion

      base_fact.insert_or_update_dead_opinion :user_opinion, user_opinion
    end

  end
end
