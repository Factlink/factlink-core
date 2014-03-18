window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  app.onClientApp = false
  app.startSiteRegions()
  app.automaticLogoutInitializer()
  app.scrollToTopInitializer()
  declareSiteRoutes()

declareSiteRoutes = ->
  new ProfileRouter controller: ProfileController # first, as then it doesn't match index pages such as "/m" using "/:username"
  new SearchRouter controller: SearchController
  new FeedsRouter controller: FeedsController
