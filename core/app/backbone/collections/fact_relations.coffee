class window.FactRelations extends Backbone.Collection
  model: FactRelation,

  initialize: (model, opts) -> this.fact = opts.fact;

  containsFactWithId: (id) ->
    for relation in @models
      fact_id =  relation.get('fact_base').fact_id
      return true if parseInt(fact_id) is parseInt(id)
    return false
