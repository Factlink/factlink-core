$(window).on 'factlink.factsLoaded', ->
  if FactlinkConfig?.client == 'bookmarklet'
    Factlink.Views.Notifications.showLoaded()
