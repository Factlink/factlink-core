window.ChannelFacts = Backbone.Collection.extend({
  model: Fact,

  initialize: function(model, opts) {
    this.channel = opts.channel;
  },

  url: function() {
    return this.channel.url() + '/facts';
  },

  loadMore: function(opts) {
    this.fetch({
      add: true,
      data: {
        timestamp: opts.timestamp
      },
      success: opts.success,
      error: opts.error
    });

  }


});