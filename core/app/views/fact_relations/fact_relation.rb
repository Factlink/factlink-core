module FactRelations
  class FactRelation < Mustache::Railstache
    def init
      self[:negative_active] = ''
      self[:positive_active] = ''

      if current_user.andand.graph_user.andand.opinion_on(self[:fact_relation]) == :believes
        self[:positive_active] = ' active'
      elsif current_user.andand.graph_user.andand.opinion_on(self[:fact_relation]) == :disbelieves
        self[:negative_active] = ' active'
      end
    end

    def to_hash
      fact_base = Facts::FactBubble.for(fact: self[:fact_relation].from_fact, view: self.view)

      fact_relation = self[:fact_relation]

      json = Jbuilder.new
      json.url friendly_fact_path(fact_relation.from_fact)
      json.signed_in? user_signed_in?
      json.can_destroy? can? :destroy, fact_relation
      json.weight fact_relation.percentage
      json.id fact_relation.id
      json.fact_relation_type fact_relation.type
      json.negative_active self[:negative_active]
      json.positive_active self[:positive_active]
      json.fact_base fact_base.to_hash

      json.attributes!.merge super
    end
  end
end
