window.Facts = Backbone.Collection.extend({
  model: Fact,
  initialize: function(models, opts) {
    this.rootUrl = opts.rootUrl;
    this.search = opts.search;
  },
  url: function() {
    if ( this.search ) {
      return '/search/?s=' + this.search ;
    } else {
      return this.rootUrl + '/facts';
    }
  }
});