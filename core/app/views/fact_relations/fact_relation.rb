module FactRelations
  class FactRelation
    def self.for(options)
      new(options[:fact_relation], options[:view])
    end

    def initialize(fact_relation, view)
      @fact_relation = fact_relation
      @view = view
    end

    def negative_active
      (current_user_opinion == :disbelieves) ? ' active' : ''
    end

    def positive_active
      (current_user_opinion == :believes) ? ' active' : ''
    end

    def current_user_opinion
      current_user = @view.current_user
      current_user.andand.graph_user.andand.opinion_on(@fact_relation)
    end

    def to_hash
      fact_relation = @fact_relation

      fact_base = Facts::FactBubble.for(fact: @fact_relation.from_fact, view: @view)

      json = Jbuilder.new

      json.url @view.friendly_fact_path(fact_relation.from_fact)
      json.signed_in? @view.user_signed_in?
      json.can_destroy? @view.can? :destroy, fact_relation
      json.weight fact_relation.percentage
      json.id fact_relation.id
      json.fact_relation_type fact_relation.type
      json.negative_active negative_active
      json.positive_active positive_active
      json.fact_base fact_base.to_hash

      json.attributes!
    end
  end
end
