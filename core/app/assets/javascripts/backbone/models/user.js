window.User = Backbone.Model.extend({
  channels: [],
  setChannels: function(channels) {
    this.channels = channels;
  },

  url: function(forProfile) {
    if (forProfile == true) {
      return '/' + this.get('username') + ".json";
    } else {
      return '/' + this.get('username') + "/channels/" + this.get('all_channel_id');
    }
  },

  sync: function(method, model, options) {
    options = options || {};
    var forProfile = options.forProfile;

    options.url = model.url(forProfile);

    Backbone.sync(method, model, options);
  }
});
