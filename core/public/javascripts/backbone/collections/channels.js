window.ChannelList = Backbone.Collection.extend({
  model: Channel,
  
  url: function() {
    return '/' + Router.getUsername() + '/channels/';
  }
});

window.Channels = new ChannelList();