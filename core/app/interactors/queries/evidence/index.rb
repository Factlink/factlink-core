require_relative '../../pavlov'

module Queries
  module Evidence
    class Index
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

      def fact_relations
        fact.evidence(@type)
      end

      def dead_fact_relations_with_opinion
        fact_relations.map do |fact_relation|
          KillObject.fact_relation(fact_relation,
            current_user_opinion: @options[:current_user].graph_user.opinion_on(fact_relation),
            get_user_opinion: fact_relation.get_user_opinion,
            evidence_class: 'FactRelation')
        end
      end

      def sort result
        result.sort do |a,b|
          OpinionPresenter.new(b.opinion).relevance <=> OpinionPresenter.new(a.opinion).relevance
        end
      end

      def comments
        if @type == :weakening
          type = 'disbelieves'
        elsif @type == :supporting
          type = 'believes'
        else
          raise 'Unsupported believe type.'
        end
        fact_data_id = fact.data_id
        Comment.where({fact_data_id: fact_data_id, type: type}).to_a
      end

      def dead_comments_with_opinion
        comments.map do |comment|
          comment = query :'comments/add_authority_and_opinion', comment, fact
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
