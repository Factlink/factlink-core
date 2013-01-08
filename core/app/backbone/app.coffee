class FactlinkAppClass extends Backbone.Marionette.Application
  startAsSite: ->
    @startSiteRegions()
    FactlinkApp.addInitializer @automaticLogoutInitializer
    FactlinkApp.addInitializer FactlinkApp.notificationsInitializer
    @start()

  startAsClient: ->
    @start()

window.FactlinkApp = new FactlinkAppClass
