window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInClient = (app) ->
  app.onClientApp = true
  app.startClientRegions()

  annotatedSiteEnvoy = window.initClientCommunicator()

  new ClientRouter controller: new ClientController(annotatedSiteEnvoy)

  FactlinkApp.discussionSidebarContainer = new DiscussionSidebarContainer
  FactlinkApp.discussionSidebarRegion.show FactlinkApp.discussionSidebarContainer

  app.vent.on 'close_discussion_sidebar', ->
    mp_track "Discussion Modal: Close (Button)"

    FactlinkApp.discussionSidebarContainer.slideOut ->
      annotatedSiteEnvoy 'closeModal'

  annotatedSiteEnvoy 'modalFrameReady', Factlink.Global.can_haz
