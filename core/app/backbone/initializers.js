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

