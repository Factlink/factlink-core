module Facts
  class FactRelation < Mustache::Railstache
    def self.for(options={})
      self.for_fact_relation_and_view(options[:fact_relation], options[:view])
    end

    def self.for_fact_relation_and_view(fact_relation, view)
      fr = new(false)
      fr.view = view
      fr[:fact_relation] = fact_relation
      fr.init
      return fr
    end

    def initialize(run=true)
      init if run
    end

    def init
    end

    def baas
      "baas"
    end

  end
end