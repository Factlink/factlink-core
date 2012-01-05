module FactRelations
  class FactRelation < Mustache::Railstache

    def fact_bubble
      Facts::FactBubble.for(fact: self[:fact_relation].from_fact, view: self.view)
    end

  end
end