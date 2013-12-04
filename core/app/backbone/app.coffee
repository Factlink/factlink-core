class FactlinkAppClass extends Backbone.Marionette.Application
  isCurrentUser: (user) ->
    Factlink.Global.signed_in and user.id == currentUser.id

window.FactlinkApp = new FactlinkAppClass

FactlinkApp.addInitializer (options) ->
  options.factlinkAppMode @, options
