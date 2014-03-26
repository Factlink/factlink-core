window.FactlinkApp = new Backbone.Marionette.Application

FactlinkApp.addInitializer (options) ->
  window.currentSession = new Session
  currentSession.fetch()

  mode = options.factlinkAppMode
  mode(@, options)

  if mode == FactlinkAppMode.coreInSite
    currentSession.on 'user_refreshed', ->
      # We still have some static user-dependent stuff on the site (not client)
      window.location.reload(true)
