window.ChannelFacts = Backbone.Collection.extend({
  model: Fact,
  _loading: undefined,
  _timestamp: undefined,
  hasMore: true,

  initialize: function(model, opts) {
    this.channel = opts.channel;
  },

  new_timestamp: function() {
    var lastModel = self.collection.models[(self.collection.length - 1) || 0];
    var new_timestamp = (lastModel ? lastModel.get('timestamp') : 0);
    return new_timestamp;
  },

  needsMore: function(){
    return this.hasMore && ! this._loading && this._timestamp !== this.new_timestamp()
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