window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  app.onClientApp = false
  app.startSiteRegions()
  window.FactlinkApp.NotificationCenter = new NotificationCenter('.js-notification-center-alerts')
  new window.NonConfirmedEmailWarning()
  app.automaticLogoutInitializer()
  declareSiteRoutes()
  enhanceSearchFormNavigation()

enhanceSearchFormNavigation = ->
  $('.js-navbar-search-form').on 'submit', ->
    console.info 'yo'
    url = '/search?s=' + encodeURIComponent $('.js-navbar-search-box').val()
    Backbone.history.navigate url, true
    false


declareSiteRoutes = ->
  new ProfileRouter #first, as then it doesn't match index pages such as "/m" using "/:username"
  new SearchRouter
  new FeedsController
