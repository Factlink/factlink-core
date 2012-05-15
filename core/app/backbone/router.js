(function(){

window.FactlinkApp = new Backbone.Marionette.Application();

FactlinkRouter = Backbone.Marionette.AppRouter.extend({
  appRoutes: {
    ':username/channels/:channel_id': 'getChannelFacts',
    ':username/channels/:channel_id/activities': 'getChannelActivities'
  }
});

FactlinkController = {

  initialize: function() {
    this.view = new AppView();
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
    var channel = this.loadChannel(username, channel_id);
    FactlinkApp.relatedUsersRegion.show(new RelatedUsersView({model: channel}));
    this.view.reInit({model: channel,content_type: 'facts'}).render();
  },

  getChannelActivities: function(username, channel_id) {
    var channel = this.loadChannel(username, channel_id);
    FactlinkApp.relatedUsersRegion.show(new RelatedUsersView({model: channel}));
    this.view.reInit({model: channel,content_type: 'activities'}).render();
  }

}

FactlinkApp.addInitializer(function(options){
  FactlinkController.initialize();
});


FactlinkApp.addInitializer(function(options){
  if ( $('#notifications').length === 1 ) {
    // The notifications-icon is present in the topbar, create the appropriate Backbone View
    var notificationsView = new NotificationsView({
      el : $('#notifications'),
      collection: new Notifications()
    });

    FactlinkApp.notificationsRegion.attachView(notificationsView);
  }
});


new FactlinkRouter({controller: FactlinkController});

FactlinkApp.addRegions({
  relatedUsersRegion: "#left-column .related-users",
  notificationsRegion: "#notifications",
  channelListRegion: "#left-column .channel-listing-container"
});



}());