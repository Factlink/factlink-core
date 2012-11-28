class Opinion < OurOhm
  module Subject
    module Fact
      def Fact.included(klass)
        klass.opinion_reference :evidence_opinion do |depth|
          opinions = evidence(:both).map { |fr| fr.get_influencing_opinion(depth-1) }
          Opinion.combine(opinions)
        end

        klass.opinion_reference :opinion do |depth|
          self.get_user_opinion(depth) + self.get_evidence_opinion( depth < 1 ? 1 : depth )
        end
      end
    end
  end
end
