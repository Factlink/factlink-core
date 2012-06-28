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

FactlinkApp.addInitializer(function(options){
  window.Channels = new ChannelList();
  window.TitleManager = new WindowTitle();

  window.Global = {}

  window.Global.TitleView = new TitleView({model: window.TitleManager, collection: window.Channels, el: 'title'});
  window.Global.TitleView.render();
});

FactlinkApp.addInitializer(function(options){
  new ChannelsRouter({controller: new ChannelsController()});
  new ProfileRouter({controller: new ProfileController()});
});