class Opinion < OurOhm
  class FactCalculation

    attr_reader :fact

    def initialize(fact)
      @fact = fact
    end

    def get_evidence_opinion
      fact.evidence_opinion || Opinion.zero
    end

    def calculate_evidence_opinion
      opinions = fact.evidence(:both).map do |fr|
        FactRelationCalculation.new(fr).get_influencing_opinion
      end
      fact.insert_or_update_opinion :evidence_opinion, Opinion.combine(opinions)
    end

    def get_opinion
      fact.opinion || Opinion.zero
    end

    def calculate_opinion
      opinion = BaseFactCalculation.new(fact).get_user_opinion + get_evidence_opinion

      fact.insert_or_update_opinion :opinion, opinion
    end

  end
end
