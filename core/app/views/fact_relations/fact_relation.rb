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

    def fact_base
      Facts::FactBubble.for(fact: self[:fact_relation].from_fact, view: self.view)
    end

    expose_to_hash :negative_active, :positive_active

    def fact_relation_type
      self[:fact_relation].type
    end

    def id
      self[:fact_relation].id
    end

    def weight
      self[:fact_relation].percentage
    end

    def can_destroy?
      can? :destroy, self[:fact_relation]
    end

    def signed_in?
      user_signed_in?
    end

    def url
      friendly_fact_path(self[:fact_relation].from_fact)
    end
  end
end
