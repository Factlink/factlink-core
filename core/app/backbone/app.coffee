window.FactlinkApp = new Backbone.Marionette.Application

FactlinkApp.addInitializer (options) ->
  options.factlinkAppMode(@, options)
