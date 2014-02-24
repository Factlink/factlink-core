class FactlinkAppClass extends Backbone.Marionette.Application
  isCurrentUser: (user) ->
    @signedIn() and user.id == currentUser.id

  signedIn: -> !!currentUser.get('username')

  refreshCurrentUser: ->
    if @mode == FactlinkAppMode.coreInClient
      currentUser.fetch()
    else
      # We still have some static user-dependent stuff on the site (not client)
      window.location.reload(true)

window.FactlinkApp = new FactlinkAppClass

FactlinkApp.addInitializer (options) ->
  window.currentUser = new CurrentUser
  currentUser.fetch()

  @mode = options.factlinkAppMode
  @mode(@, options)
