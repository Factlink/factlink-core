window.FactRelations = Backbone.Collection.extend({
  model: FactRelation,

  initialize: function(model, opts) {
    this.fact = opts.fact;
  }
});