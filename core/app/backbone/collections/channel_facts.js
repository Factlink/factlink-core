window.ChannelFacts = Backbone.Collection.extend({
  model: Fact,
  _loading: undefined,
  _timestamp: undefined,
  hasMore: true,

  initialize: function(model, opts) {
    this.channel = opts.channel;
  },

  new_timestamp: function() {
    self = this;
    var lastModel = self.models[(self.length - 1) || 0];
    var new_timestamp = (lastModel ? lastModel.get('timestamp') : 0);
    return new_timestamp;
  },

  startLoading: function(){
    this._loading = true;
    this.trigger('startLoading',this);
  },

  stopLoading: function(){
    this._loading = false;
    this.trigger('stopLoading',this);
  },

  needsMore: function(){
    return this.hasMore && ! this._loading && this._timestamp !== this.new_timestamp()
  },

  url: function() {
    return this.channel.url() + '/facts';
  },

  loadMore: function() {
    self = this;
    this.startLoading();
    this.fetch({
      add: true,
      data: {
        timestamp: this._timestamp
      },
      success: function() {
        self.stopLoading();
      },
      error: function() {
        self.stopLoading();
        self.hasMore = false;
      }
    });
  }

});