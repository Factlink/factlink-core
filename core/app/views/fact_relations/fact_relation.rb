module FactRelations
  class FactRelation < Mustache::Railstache

    def fact_bubble
      Facts::FactBubble.for_fact_and_view(self[:fact_relation].from_fact, self.view)
    end

  end
end