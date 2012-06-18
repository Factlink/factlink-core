window.ChannelFacts = Backbone.Collection.extend({
  model: Fact,
  _loading: undefined,
  _timestamp: undefined,
  hasMore: true,

  initialize: function(model, opts) {
    this.channel = opts.channel;
    this.on('add',this.updateTimestamp,this);
  },


  updateTimestamp: function(){
    var lastModel = this.models[(self.length - 1) || 0];
    this._timestamp = (lastModel ? lastModel.get('timestamp') : 0);
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
    return this.hasMore && ! this._loading;
  },

  url: function() {
    return this.channel.url() + '/facts';
  },

  loadMore: function() {
    if( ! this.needsMore() ) {return;}
    this.startLoading();
    this.fetch({
      add: true,
      data: {
        timestamp: this._timestamp
      },
      success: _.bind(function() {
        this.stopLoading();
      }, this),
      error: _.bind(function() {
        this.stopLoading();
        this.hasMore = false;
      }, this)
    });
  }

});