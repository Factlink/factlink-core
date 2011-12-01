window.Facts = Backbone.Collection.extend({
  model: Fact,
  initialize: function(models, opts) {
    this.rootUrl = opts.rootUrl;
  },
  url: function() {
    return this.rootUrl + '/facts';
  }
});