window.ChannelList = Backbone.Collection.extend({
  model: Channel,
  url: function() {
    var username = location.pathname.split("/")[1];
    
    return '/' + username + '/channels/';
  }
});

window.Channels = new ChannelList();