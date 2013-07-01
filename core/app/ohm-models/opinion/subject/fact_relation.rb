class Opinion < OurOhm
  module Subject
    module FactRelation
      def self.included(klass)
        klass.send :alias_method, :get_opinion, :get_user_opinion
        klass.send :alias_method, :calculate_opinion, :calculate_user_opinion

        klass.opinion_reference :influencing_opinion do |depth|
          truth = from_fact.get_opinion(depth)
          relevance = get_user_opinion(depth)

          auth = [truth.positive_opinion.a, relevance.positive_opinion.a].min
          xtype = OpinionType.for_relation_type(self.type)
          Opinion.for_type(xtype,auth)
        end
      end
    end
  end
end
