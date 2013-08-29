FactlinkApp.notificationsInitializer = (options) ->
  return unless FactlinkApp.notificationsRegion?

  notificationsView = new NotificationsView collection: new Notifications()
  FactlinkApp.notificationsRegion.show(notificationsView)
