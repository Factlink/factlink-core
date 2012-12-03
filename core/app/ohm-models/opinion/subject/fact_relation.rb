class Opinion < OurOhm
  module Subject
    module FactRelation

      def FactRelation.included(klass)
        klass.send :alias_method, :get_opinion, :get_user_opinion
        klass.send :alias_method, :calculate_opinion, :calculate_user_opinion

        klass.opinion_reference :influencing_opinion do |depth|
          get_type_opinion.dfa(self.from_fact.get_opinion(depth), self.get_user_opinion(depth))
        end
      end
    end
  end
end
