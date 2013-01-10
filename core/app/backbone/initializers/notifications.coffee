FactlinkApp.notificationsInitializer = (options)->
  if $('#notifications').length == 1
    notificationsView = new NotificationsView(
      el : $('#notifications')
      collection: new Notifications()
    )

    FactlinkApp.notificationsRegion.attachView(notificationsView)
