window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInClient = (app) ->
  app.startClientRegions()

  annotatedSiteEnvoy = window.initClientCommunicator()

  new ClientRouter controller: new ClientController(annotatedSiteEnvoy)

  FactlinkApp.discussionSidebarContainer = new DiscussionSidebarContainer
    annotatedSiteEnvoy: annotatedSiteEnvoy
  FactlinkApp.discussionSidebarRegion.show FactlinkApp.discussionSidebarContainer

  app.vent.on 'close_discussion_sidebar', ->
    mp_track "Discussion Sidebar: Close (Button)"

    FactlinkApp.discussionSidebarContainer.slideOut ->
      annotatedSiteEnvoy 'closeModal'

  window.addEventListener 'keydown', (e) ->
    if e.keyCode == 27
      e.preventDefault()
      e.stopPropagation()
      app.vent.trigger 'close_discussion_sidebar'

  annotatedSiteEnvoy 'modalFrameReady', Factlink.Global.can_haz
