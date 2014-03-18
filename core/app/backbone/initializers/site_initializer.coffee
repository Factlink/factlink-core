window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  app.onClientApp = false
  app.startSiteRegions()
  app.automaticLogoutInitializer()
  app.scrollToTopInitializer()
  declareSiteRoutes()

declareSiteRoutes = ->
  new ProfileRouter #first, as then it doesn't match index pages such as "/m" using "/:username"
  new SearchRouter
  new FeedsController
