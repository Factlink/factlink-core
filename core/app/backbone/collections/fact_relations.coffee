class window.FactRelations extends Backbone.Collection
  model: FactRelation,

  initialize: (model, opts) -> this.fact = opts.fact;

  url: -> @fact.url() + "/#{@type}_evidence"

class window.WeakeningFactRelations extends FactRelations
  type: "weakening"

class window.SupportingFactRelations extends FactRelations
  type: "supporting"
