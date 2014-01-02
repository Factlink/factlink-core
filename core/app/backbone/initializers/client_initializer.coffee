window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInClient = (app) ->
  app.onClientApp = true
  app.startClientRegions()

  annotatedSiteEnvoy = window.initClientCommunicator()

  new ClientRouter controller: new ClientController(annotatedSiteEnvoy)

  app.vent.on 'close_discussion_modal', ->
    mp_track "Discussion Modal: Close (Button)"
    annotatedSiteEnvoy 'closeModal'

  annotatedSiteEnvoy 'modalFrameReady', Factlink.Global.can_haz
