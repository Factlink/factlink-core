class Opinion < OurOhm
  module Subject
    module Fact

      def get_evidence_opinion(depth=0)
        calculate_evidence_opinion if depth > 0
        evidence_opinion || Opinion.zero
      end

      def calculate_evidence_opinion(depth=0)
        opinions = evidence(:both).map { |fr| fr.get_influencing_opinion(depth-1) }
        set_opinion :evidence_opinion, Opinion.combine(opinions)
      end

      def get_opinion(depth=0)
        calculate_opinion if depth > 0
        opinion || Opinion.zero
      end

      def calculate_opinion(depth=0)
        set_opinion :opinion, self.get_user_opinion(depth) + self.get_evidence_opinion( depth < 1 ? 1 : depth )
      end

    end
  end
end
