Factlink.commonInitializer = ->
  Factlink.vent = _.extend {}, Backbone.Events

  window.currentSession = new Session
  currentSession.fetch()
