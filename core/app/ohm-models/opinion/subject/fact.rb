class Opinion < OurOhm
  module Subject
    module Fact

      def self.included(klass)
        klass.reference :evidence_opinion, Opinion
        klass.reference :opinion, Opinion
      end

      def get_evidence_opinion(depth=0)
        calculate_evidence_opinion if depth > 0
        evidence_opinion || Opinion.zero
      end

      def set_evidence_opinion(new_opinion)
        if evidence_opinion
          evidence_opinion.take_values new_opinion
        else
          new_opinion.save
          send :"evidence_opinion=", new_opinion
        end
      end

      def calculate_evidence_opinion(depth=0)
        opinions = evidence(:both).map { |fr| fr.get_influencing_opinion(depth-1) }
        set_evidence_opinion Opinion.combine(opinions)
      end

      def get_opinion(depth=0)
        calculate_opinion if depth > 0
        opinion || Opinion.zero
      end

      def set_opinion(new_opinion)
        if opinion
          opinion.take_values new_opinion
        else
          new_opinion.save
          send :"opinion=", new_opinion
        end
      end

      def calculate_opinion(depth=0)
        set_opinion self.get_user_opinion(depth) + self.get_evidence_opinion( depth < 1 ? 1 : depth )
      end

    end
  end
end
