window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  app.onClientApp = false
  app.linkTarget = '_self'
  app.startSiteRegions()
  app.automaticLogoutInitializer()
  app.notificationsInitializer()
  app.scrollToTopInitializer()
  declareSiteRoutes()

  if Factlink.Global.can_haz.christmas_background
    $('html').addClass 'feature_christmas_background'

declareSiteRoutes = ->
  profileController = new ProfileController # For use in ChannelsController
  new ProfileRouter controller: profileController # first, as then it doesn't match index pages such as "/m" using "/:username"
  new SearchRouter controller: new SearchController
  new ChannelsRouter
    controller: new ChannelsController
      showProfile: (username) -> profileController.showProfile username
  new TourRouter controller: new TourController

