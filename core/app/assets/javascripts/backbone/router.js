var Workspace = Backbone.Router.extend({
  initialize: function(opts) {
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/?$/, "getChannelFacts", this.getChannelFacts);
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/activities\/?$/, "getChannelActivities", this.getChannelActivities);

    this.view = new AppView();

    this._username = opts.username;
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