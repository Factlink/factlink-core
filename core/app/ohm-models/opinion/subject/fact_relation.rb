class Opinion < OurOhm
  module Subject
    module FactRelation
      def self.included(klass)
        klass.send :alias_method, :get_opinion, :get_user_opinion
        klass.send :alias_method, :calculate_opinion, :calculate_user_opinion

        klass.opinion_reference :influencing_opinion do |depth|
          net_fact_authority = from_fact.get_opinion(depth).net_authority
          net_relevance_authority = get_user_opinion(depth).net_authority

          authority = [[net_fact_authority, net_relevance_authority].min, 0].max

          xtype = OpinionType.for_relation_type(self.type)
          Opinion.for_type(xtype, authority)
        end
      end
    end
  end
end
