window.ChannelList = Backbone.Collection.extend({
  model: Channel,
  url: '/tomdev/channels/'
});

window.Channels = new ChannelList;