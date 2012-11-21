class window.FactRelations extends Backbone.Collection
  model: FactRelation,

  initialize: (model, opts) -> this.fact = opts.fact
