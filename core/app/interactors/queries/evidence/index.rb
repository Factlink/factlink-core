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
     #add mock data:
        comment1 = Comment.first
        c1 = KillObject.comment comment1,
              opinion: Opinion.new(:b=>1,:d=>0,:u=>0,:a=>178),
              current_user_opinion: 192,
              authority: 144,
              evidence_class: 'Comment'

        comment2 = Comment.last
        c2 = KillObject.comment comment2,
              opinion: Opinion.new(:b=>1,:d=>0,:u=>0,:a=>4),
              current_user_opinion: 27,
              authority: 12,
              evidence_class: 'Comment'

        fact_relation = FactRelation.all.first
        f1 = KillObject.fact_relation fact_relation,
              current_user_opinion: @options[:current_user].graph_user.opinion_on(fact_relation),
              evidence_class: 'FactRelation',
              get_user_opinion: Opinion.new(:b=>1,:d=>0,:u=>0,:a=>34)

        [c1, c2, f1]
      end
    # comments = interactor :"comments/index", fact_id, relation

    # #todo add to authenticate of interactor
    # @fact = Fact[params[:fact_id]] || raise_404("Fact not found")

    # # todo add to query:
    # @evidence = @fact.evidence(relation)

    # @fact_relations = @evidence.to_a.sort do |a,b|
    #   OpinionPresenter.new(b.get_user_opinion).relevance <=> OpinionPresenter.new(a.get_user_opinion).relevance
    # end
    end
  end
end
