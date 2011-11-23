window.ChannelList = Backbone.Collection.extend({
  model: Channel,
  
  initialize: function() {
    this.bind('activate', this.setActiveChannel);
    this.bind('reset', this.checkActiveChannel);
  },
  
  url: function() {
    return '/' + Router.getUsername() + '/channels/';
  },
  
  setActiveChannel: function(channel) {
    if ( this.activeChannelId && this.activeChannelId !== channel.id ) {
      this.get(this.activeChannelId).trigger('deactivate');
    }
    
    this.activeChannelId = channel.id;
  },
  
  checkActiveChannel: function() {
    if ( this.activeChannelId ) {
      var activeChannel = this.get(this.activeChannelId);
      
      activeChannel.trigger('activate', activeChannel);
    }
  }
});

window.Channels = new ChannelList();