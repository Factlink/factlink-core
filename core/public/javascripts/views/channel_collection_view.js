var views = {};
var active_channel_id;

window.ChannelCollectionView = Backbone.View.extend({
  el: $('#left-column'),
  
  initialize: function(opts) {
    var self = this;

    Channels.bind('add',   this.addOneChannel, this);
    Channels.bind('reset', this.resetChannels, this);
    Channels.bind('all',   this.render, this);
    
    this.appView = opts.appView;

    this.appView.bind('channels:loading', function(channel_id) {
      self.setLoading(channel_id);
    }).bind('channels:loaded', function(channel_id) {
      self.stopLoading(channel_id);
      self.setActiveChannel(channel_id);
    });

    var current_channel_id = $('#channel').data('channel-id');
    
    if ( current_channel_id ) {
      // Calling toString on the channel-id because backbone 
      // stores id as string (=== comparison)
      this.setActiveChannel(current_channel_id.toString());
    }
  },
  
  addOneChannel: function(channel) {
    var view = new ChannelItemView({model: channel});
    
    views[channel.id] = view;
    
    if ( this.isActiveChannel(channel.id) ) {
      view.setActive();
    }
    
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
  },
  
  isActiveChannel: function(channel_id) {
    return active_channel_id === channel_id;
  },
  
  setActiveChannel: function(channel_id) {
    if ( active_channel_id ) {
      views[active_channel_id].setNotActive();
    }
        
    active_channel_id = channel_id;
    
    if ( views[active_channel_id] ) {
      views[active_channel_id].setActive();
    }
  }
});
