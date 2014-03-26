class FactlinkAppClass extends Backbone.Marionette.Application
  refreshCurrentUser: (response) ->
    if @mode == FactlinkAppMode.coreInClient
      currentSession.user().set response
    else
      # We still have some static user-dependent stuff on the site (not client)
      window.location.reload(true)

window.FactlinkApp = new FactlinkAppClass

FactlinkApp.addInitializer (options) ->
  window.currentSession = new Session
  currentSession.fetch()

  @mode = options.factlinkAppMode
  @mode(@, options)
