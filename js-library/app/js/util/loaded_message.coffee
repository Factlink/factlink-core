$(window).on 'factlink.factsLoaded', ->
  if FactlinkConfig?.client == 'bookmarklet'
    FACTLINK.Views.Notifications.showLoaded()
