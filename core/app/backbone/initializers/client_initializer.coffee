window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInClient = (app) ->
  app.onClientApp = true
  app.startClientRegions()

  annotatedSiteEnvoy = window.initClientCommunicator()

  new ClientRouter controller: new ClientController(annotatedSiteEnvoy)

  FactlinkApp.discussionModalContainer = new DiscussionModalContainer
  FactlinkApp.discussionModalRegion.show FactlinkApp.discussionModalContainer

  app.vent.on 'close_discussion_modal', ->
    mp_track "Discussion Modal: Close (Button)"

    FactlinkApp.discussionModalContainer.slideOut ->
      annotatedSiteEnvoy 'closeModal'

  annotatedSiteEnvoy 'modalFrameReady', Factlink.Global.can_haz
