class FactlinkAppClass extends Backbone.Marionette.Application
  startAsSite: ->
    @startSiteRegions()
    @addInitializer @automaticLogoutInitializer
    @addInitializer @notificationsInitializer
    @addInitializer @scrollToTopInitializer

    @linkTarget = '_self'

    @addInitializer (options)->
      # For use in ChannelsController
      @ProfileController = new ProfileController

      new ProfileRouter controller: @ProfileController # first, as then it doesn't match index pages such as "/m" using "/:username"
      new SearchRouter controller: new SearchController
      new ChannelsRouter controller: new ChannelsController
      new ConversationsRouter controller: new ConversationsController
      new TourRouter controller: new TourController

    @start()

  startAsClient: ->
    @startClientRegions()
    @addInitializer (options)->
      new ClientRouter controller: ClientController
    @addInitializer @clientCloseDiscussionModalInitializer
    @modal = true
    @onClientApp = true
    # remote should always be loaded, however, in tests it's not...
    # TODO: test via fake wrapper
    parent.annotatedSiteEnvoy?.modalFrameReady Factlink.Global.can_haz
    @start()

  isCurrentUser: (user) ->
    Factlink.Global.signed_in and user.id == currentUser.id

window.FactlinkApp = new FactlinkAppClass
