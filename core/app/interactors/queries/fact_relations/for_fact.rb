require 'pavlov'

module Queries
  module FactRelations
    class ForFact
      include Pavlov::Query

      arguments :fact, :type

      def execute
        dead_fact_relations_with_opinion
      end

      def fact_relations
        fact.evidence(@type)
      end

      def dead_fact_relations_with_opinion
        fact_relations.map do |fact_relation|
          fact_relation.sub_comments_count = query :'sub_comments/count', fact_relation.id.to_s, fact_relation.class.to_s
          opinion = query :'opinions/relevance_opinion_for_fact_relation', fact_relation

          KillObject.fact_relation(fact_relation,
            current_user_opinion: current_user_opinion_on(fact_relation),
            opinion: opinion,
            evidence_class: 'FactRelation')
        end
      end

      def current_user_opinion_on fact_relation
        return unless @options[:current_user]

        @options[:current_user].graph_user.opinion_on(fact_relation)
      end
    end
  end
end
