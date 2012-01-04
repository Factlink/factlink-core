window.FactRelations = Backbone.Collection.extend({
  model: FactRelation,

  initialize: function(model, opts) {
    this.fact = opts.fact;
  },

  url: function() {
    return this.fact.url() + '/fact_relations';
  }
});