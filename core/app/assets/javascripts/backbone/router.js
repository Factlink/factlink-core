var Workspace = Backbone.Router.extend({
  initialize: function(opts) {
    this.route(/([^\/]+)\/channels\/([0-9]+|all)$/, "getChannelFacts", this.getChannelFacts);
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/activities$/, "getChannelActivities", this.getChannelActivities);

    this.view = new AppView();

    this._username = opts.username;
  },

  loadChannel: function(channel_id) {
    var channel = Channels.get(channel_id);

    try {
      mpmetrics.track("mp_page_view", {
        mp_page: window.location.href
      });
    } catch(e) {}

    if ( !channel ) {
      channel = this.view.channelView.subchannels.get(channel_id);
    }

    channel.set({new_facts: false});
    return channel;
  },

  getChannelFacts: function(username, channel_id) {
    this.view.reInit({model: this.loadChannel(channel_id),content_type: 'facts'}).render();
  },

  getChannelActivities: function(username, channel_id) {
    this.view.reInit({model: this.loadChannel(channel_id),content_type: 'activities'}).render();
  },

  getUsername: function() {
    if ( this._username ) {
      return this._username;
    }

    return false;
  }

});