class FactlinkAppClass extends Backbone.Marionette.Application
  startAsSite: ->
    @startSiteRegions()
    FactlinkApp.addInitializer @automaticLogoutInitializer
    FactlinkApp.addInitializer FactlinkApp.notificationsInitializer

    FactlinkApp.addInitializer (options)->
      new ProfileRouter controller: new ProfileController # first, as then it doesn't match index pages such as "/m" using "/:username"
      new ChannelsRouter controller: new ChannelsController
      new ConversationsRouter controller: new ConversationsController
      # the choose-channels in the tour uses the startAsSite
      new TourRouter controller: new TourController

    @start()

  startAsTour: ->
    FactlinkApp.addInitializer (options)->
      new TourRouter controller: new TourController

    @start()

  startAsClient: ->
    @start()

window.FactlinkApp = new FactlinkAppClass
