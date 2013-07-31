require 'pavlov'

module Queries
  module FactRelations
    class AddSubCommentsCountAndOpinionsAndEvidenceClass
      include Pavlov::Query

      arguments :fact_relation

      private

      def validate
        validate_not_nil :fact_relation, fact_relation
      end

      def execute
        fact_relation.sub_comments_count = old_query :'sub_comments/count', fact_relation.id.to_s, fact_relation.class.to_s
        impact_opinion = old_query :'opinions/impact_opinion_for_fact_relation', fact_relation

        KillObject.fact_relation fact_relation,
          current_user_opinion: current_user_opinion_on(fact_relation),
          impact_opinion: impact_opinion,
          evidence_class: 'FactRelation'
      end

      def current_user_opinion_on fact_relation
        return unless pavlov_options[:current_user]

        pavlov_options[:current_user].graph_user.opinion_on(fact_relation)
      end
    end
  end
end
