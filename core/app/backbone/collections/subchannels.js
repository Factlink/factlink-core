window.SubchannelList = Backbone.Collection.extend({
  model: Subchannel,
  
  initialize: function(opts) {
    this.channel = opts.channel;
  },
  
  url: function() {
    return this.channel.url() + '/subchannels';
  }
});