var Workspace = Backbone.Router.extend({
  initialize: function(opts) {
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/?$/, "getChannelFacts", this.getChannelFacts);

    this.view = new AppView();

    this._username = opts.username;
  },

  getChannelFacts: function(username, channel_id) {
    var channel = Channels.get(channel_id);

    if ( !channel ) {
      channel = this.view.channelView.subchannels.get(channel_id);
    }

    channel.set({new_facts: false});

    this.view.openChannel(channel).render();
  },

  getUsername: function() {
    if ( this._username ) {
      return this._username;
    }

    return false;
  }

});