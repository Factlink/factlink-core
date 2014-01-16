window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  app.onClientApp = false
  app.linkTarget = '_self'
  app.startSiteRegions()
  app.automaticLogoutInitializer()
  app.notificationsInitializer()
  app.scrollToTopInitializer()
  declareSiteRoutes()

declareSiteRoutes = ->
  profileController = new ProfileController # For use in FactsController
  new ProfileRouter controller: profileController # first, as then it doesn't match index pages such as "/m" using "/:username"
  new SearchRouter controller: new SearchController
  new FactsRouter
    controller: new FactsController
      showProfile: (username) -> profileController.showProfile username
  new TourRouter controller: new TourController

