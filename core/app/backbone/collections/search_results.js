window.SearchResults = Backbone.Collection.extend({
  model: SearchResultItem,
  initialize: function(models, opts) {
    this.search = opts.search;
  },
  url: function() {
    return '/search/?s=' + this.search;
  }
});