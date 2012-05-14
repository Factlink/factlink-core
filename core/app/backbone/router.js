(function(){
window.Workspace = Backbone.Router.extend({
  initialize: function(opts) {
    this.route(/([^\/]+)\/channels\/([0-9]+|all)$/, "getChannelFacts", this.getChannelFacts);
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/activities$/, "getChannelActivities", this.getChannelActivities);

    this.view = new AppView();

    if ( $('#notifications').length === 1 ) {
      // The notifications-icon is present in the topbar, create the appropriate Backbone View
      this.notificationsView = new NotificationsView({
        el : $('#notifications'),
        collection: new Notifications()
      });

      this.notificationsView.render();
    }
  },

  loadChannel: function(username, channel_id) {
    var channel = Channels.get(channel_id);
    Channels.setUsername(username);

    try {
      mpmetrics.track("mp_page_view", {
        mp_page: window.location.href
      });
    } catch(e) {}

    if ( !channel ) {
      channel = this.view.channelView.subchannels.get(channel_id);
      channel.collection = Channels;
    }
    channel.set({new_facts: false});
    return channel;
  },

  getChannelFacts: function(username, channel_id) {
    this.view.reInit({model: this.loadChannel(username, channel_id),content_type: 'facts'}).render();
  },

  getChannelActivities: function(username, channel_id) {
    this.view.reInit({model: this.loadChannel(username, channel_id),content_type: 'activities'}).render();
  }

});
}());