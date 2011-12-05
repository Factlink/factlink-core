window.FactList = Backbone.Collection.extend({
  model: Fact,
  url: function() {
    if (this.forChannel !== undefined) {
      return Channels.get(this.forChannel).url() + '/facts/';
    } else {
      return '/tomdev/channels/';
    }
  }
});

window.Facts = new FactList();