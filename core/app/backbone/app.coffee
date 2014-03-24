class FactlinkAppClass extends Backbone.Marionette.Application
  isCurrentUser: (user) ->
    @signedIn() and user.id == session.user().id

  signedIn: -> !!session.user().get('username')

  refreshCurrentUser: (response) ->
    if @mode == FactlinkAppMode.coreInClient
      session.user().set response
    else
      # We still have some static user-dependent stuff on the site (not client)
      window.location.reload(true)

window.FactlinkApp = new FactlinkAppClass

FactlinkApp.addInitializer (options) ->
  window.session = new Session
  session.fetch()

  @mode = options.factlinkAppMode
  @mode(@, options)
