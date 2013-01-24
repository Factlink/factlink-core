class FactlinkAppClass extends Backbone.Marionette.Application
  startAsSite: ->
    @startSiteRegions()
    @addInitializer @automaticLogoutInitializer
    @addInitializer @notificationsInitializer

    @linkTarget = '_self'

    @addInitializer (options)->
      new ProfileRouter controller: new ProfileController # first, as then it doesn't match index pages such as "/m" using "/:username"
      new ChannelsRouter controller: new ChannelsController
      new ConversationsRouter controller: new ConversationsController
      new TourRouter controller: new TourController

    @start()

  startAsClient: ->
    @startClientRegions()
    @addInitializer (options)->
      new ClientRouter controller: new ClientController
    @modal = true
    @linkTarget = '_blank'

    @start()

window.FactlinkApp = new FactlinkAppClass
