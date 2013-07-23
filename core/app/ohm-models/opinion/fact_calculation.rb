class Opinion < OurOhm
  class FactCalculation

    attr_reader :fact

    def initialize(fact)
      @fact = fact
    end

    def get_evidence_opinion(depth=0)
      calculate_evidence_opinion if depth > 0
      fact.evidence_opinion || Opinion.zero
    end

    def calculate_evidence_opinion(depth=0)
      opinions = fact.evidence(:both).map do |fr|
        FactRelationCalculation.new(fr).get_influencing_opinion(depth-1)
      end
      fact.set_opinion_of_type :evidence_opinion, Opinion.combine(opinions)
    end

    def get_opinion(depth=0)
      calculate_opinion if depth > 0
      fact.opinion || Opinion.zero
    end

    def calculate_opinion(depth=0)
      opinion = fact.get_user_opinion(depth) + FactCalculation.new(fact).get_evidence_opinion( depth < 1 ? 1 : depth )
      fact.set_opinion_of_type :opinion, opinion
    end

  end
end
