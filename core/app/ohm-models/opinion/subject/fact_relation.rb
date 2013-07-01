class Opinion < OurOhm
  module Subject
    module FactRelation
      def self.included(klass)
        klass.send :alias_method, :get_opinion, :get_user_opinion
        klass.send :alias_method, :calculate_opinion, :calculate_user_opinion

        klass.opinion_reference :influencing_opinion do |depth|
          truth = from_fact.get_opinion(depth)
          relevance = get_user_opinion(depth)
          get_type_opinion.calculate_impact(truth, relevance)
        end
      end
    end
  end
end
