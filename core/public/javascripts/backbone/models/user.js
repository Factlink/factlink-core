window.User = Backbone.Model.extend({
  channels: [],
  setChannels: function(channels) {
    this.channels = channels;
  },
  
  url: function() {
    return '/' + this.get('username');
  }
});