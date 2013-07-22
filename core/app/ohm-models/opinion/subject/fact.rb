class Opinion < OurOhm
  module Subject
    module Fact

      OurOhm.value_reference :evidence_opinion, Opinion

      def calculate_evidence_opinion(depth=0)
        opinions = evidence(:both).map { |fr| fr.get_influencing_opinion(depth-1) }
        send :"evidence_opinion=", Opinion.combine(opinions)
      end

      def get_opinion(depth=0)
        calculate_evidence_opinion if depth > 0
        evidence_opinion || Opinion.zero
      end

      OurOhm.value_reference :opinion, Opinion

      def calculate_opinion(depth=0)
        send :"opinion=", self.get_user_opinion(depth) + self.get_evidence_opinion( depth < 1 ? 1 : depth )
      end

      def get_opinion(depth=0)
        calculate_opinion if depth > 0
        opinion || Opinion.zero
      end

    end
  end
end
