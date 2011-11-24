window.User = Backbone.Model.extend({
  channels: [],
  setChannels: function(channels) {
    this.channels = channels;
  }
});