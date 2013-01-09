FactlinkApp.notificationsInitializer = (options)->
  notificationsView = new NotificationsView(
    el : $('#notifications')
    collection: new Notifications()
  )

  FactlinkApp.notificationsRegion.attachView(notificationsView)
