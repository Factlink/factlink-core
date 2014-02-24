class FactlinkAppClass extends Backbone.Marionette.Application
  isCurrentUser: (user) ->
    @signedIn() and user.id == currentUser.id

  signedIn: -> currentUser.get('username')

window.FactlinkApp = new FactlinkAppClass

FactlinkApp.addInitializer (options) ->
  options.factlinkAppMode @, options
