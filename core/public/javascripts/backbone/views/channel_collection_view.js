var views = {};
var activeChannel;

window.ChannelCollectionView = Backbone.View.extend({
  el: $('#left-column'),
  
  initialize: function(opts) {
    var self = this;

    Channels.bind('add',   this.addOneChannel, this);
    Channels.bind('reset', this.resetChannels, this);
    
    this.appView = opts.appView;
    
    // Hacky way to make sure Backbone will refollow the current route
    this.el.find('li.active').live('click', function(e) {
      Backbone.history.loadUrl( Backbone.history.fragment );
    });
  },
  
  addOneChannel: function(channel) {
    var view = new ChannelItemView({model: channel});
    
    views[channel.id] = view;
    
    this.$('#channel-listing').append(view.render().el);
  },

  setLoading: function(channel_id) {
    views[channel_id].setLoading();
  },
  
  stopLoading: function(channel_id) {
    views[channel_id].stopLoading();
  },

  resetChannels: function() {
    var self = this;
    _.each(views,function(view) {
      view.remove();
    });
    Channels.each(function(channel) {
      self.addOneChannel.call(self, channel);
    });
  }
});
