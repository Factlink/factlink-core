window.ChannelList = Backbone.Collection.extend({
  model: Channel,
  
  initialize: function() {
    this.bind('activate', this.setActiveChannel);
  },
  
  url: function() {
    return '/' + Router.getUsername() + '/channels/';
  },
  
  setActiveChannel: function(channel) {
    if ( this.activeChannel && this.activeChannel.id !== channel.id ) {
      this.activeChannel.trigger('deactivate');
    }
    
    this.activeChannel = channel;
  }
});

window.Channels = new ChannelList();