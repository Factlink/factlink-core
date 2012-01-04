window.SearchFacts = Backbone.Collection.extend({
  model: Fact,
  initialize: function(models, opts) {
    this.search = options.search;
  },
  url: function() {
    return '/search/?s=' + this.search;
  }
});