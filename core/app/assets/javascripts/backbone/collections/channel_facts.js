window.ChannelFacts = Backbone.Collection.extend({
  model: Fact,

  initialize: function(model, opts) {
    this.channel = opts.channel;
  },

  url: function() {
    return this.channel.url() + '/facts';
  }
});