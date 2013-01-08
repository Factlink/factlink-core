class FactlinkAppClass extends Backbone.Marionette.Application
  startAsSite: ->
    @startSiteRegions()
    FactlinkApp.addInitializer @automaticLogoutInitializer
    @start()

  startAsClient: ->
    @start()

window.FactlinkApp = new FactlinkAppClass
