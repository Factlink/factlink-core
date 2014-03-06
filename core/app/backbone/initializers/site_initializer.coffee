window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  app.onClientApp = false
  app.linkTarget = '_self'
  app.startSiteRegions()
  app.automaticLogoutInitializer()
  app.scrollToTopInitializer()
  declareSiteRoutes()

declareSiteRoutes = ->
  new ProfileRouter controller: new ProfileController # first, as then it doesn't match index pages such as "/m" using "/:username"
  new SearchRouter controller: new SearchController
  new FeedsRouter controller: new FeedsController
