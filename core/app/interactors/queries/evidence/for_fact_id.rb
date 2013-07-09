require 'pavlov'

module Queries
  module Evidence
    class ForFactId
      include Pavlov::Query

      arguments :fact_id, :type

      def validate
        validate_integer_string :fact_id, @fact_id
        validate_in_set         :type,    @type, [:weakening, :supporting]
      end

      def execute
        result = dead_fact_relations_with_opinion + dead_comments_with_opinion

        sort result
      end

      def dead_fact_relations_with_opinion
        query :'fact_relations/for_fact', fact, type
      end

      def current_user_opinion_on fact_relation
        return unless @options[:current_user]

        @options[:current_user].graph_user.opinion_on(fact_relation)
      end

      def sort result
        result.sort do |a,b|
          OpinionPresenter.new(b.opinion).relevance <=> OpinionPresenter.new(a.opinion).relevance
        end
      end

      def comments
        type = OpinionType.for_relation_type(@type).to_s
        fact_data_id = fact.data_id
        Comment.where({fact_data_id: fact_data_id, type: type}).to_a
      end

      def dead_comments_with_opinion
        comments.map do |comment|
          comment.sub_comments_count = query :'sub_comments/count', comment.id.to_s, comment.class.to_s
          comment = query :'comments/add_authority_and_opinion_and_can_destroy', comment, fact
          # TODO: don't depend on the fact that comment is an openstruct
          comment.evidence_class = 'Comment'

          comment
        end
      end

      def fact
        @fact ||= Fact[@fact_id]
      end
    end
  end
end
