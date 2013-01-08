class FactlinkAppClass extends Backbone.Marionette.Application
  startAsSite: ->
    @startSiteRegions()
    @start()

  startAsClient: ->
    @start()

window.FactlinkApp = new FactlinkAppClass
