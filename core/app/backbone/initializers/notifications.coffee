FactlinkApp.notificationsInitializer = ->
  return unless FactlinkApp.notificationsRegion?
  return unless Factlink.Global.signed_in

  notificationsView = new NotificationsView collection: new Notifications()
  FactlinkApp.notificationsRegion.show(notificationsView)
