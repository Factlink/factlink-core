window.FactlinkApp = new Backbone.Marionette.Application

FactlinkApp.addInitializer (options) ->
  window.currentSession = new Session
  currentSession.fetch()

  options.factlinkAppMode(@, options)
