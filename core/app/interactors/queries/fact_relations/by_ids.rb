require 'pavlov'

module Queries
  module FactRelations
    class ByIds
      include Pavlov::Query

      arguments :fact_relation_ids

      private

      def validate
        fact_relation_ids.each do |fact_relation_id|
          validate_integer_string :fact_relation_id, fact_relation_id
        end
      end

      def execute
        fact_relation_ids.map do |fact_relation_id|
          fact_relation = FactRelation[fact_relation_id]

          unless fact_relation
            raise ActionController::RoutingError.new('FactRelation could not be found')
          end

          dead_fact_relation_for fact_relation
        end
      end

      def dead_fact_relation_for fact_relation
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
