# Object which holds the methods that can be called from the factlink core iframe

modalOpen = false

FactlinkJailRoot.annotatedSiteReceiver =
  modalFrameReady: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    FactlinkJailRoot.core_loaded_promise.resolve()

  openModalOverlay: ->
    if modalOpen
      console.error 'trying to open an already open modal: bug?'
      return
    FactlinkJailRoot.$sidebarFrame.addClass 'factlink-sidebar-frame-visible'
    modalOpen = true
    FactlinkJailRoot.trigger 'modalOpened'

  highlightNewFactlink: (displaystring, id) ->
    FactlinkJailRoot.highlightFact(displaystring, id)
    FactlinkJailRoot.trigger 'factlinkAdded'
    FactlinkJailRoot.showCoreHighlight id

  highlightExistingFactlink: (id) ->
    FactlinkJailRoot.showCoreHighlight id

  deleteFactlink: FactlinkJailRoot.destroyCoreHighlight

  closeModal: ->
    if !modalOpen
      console.error 'trying to close an already closed modal: bug?'
      return
    modalOpen = false

    FactlinkJailRoot.trigger 'modalClosed'
    FactlinkJailRoot.$sidebarFrame.removeClass 'factlink-sidebar-frame-visible'
    FactlinkJailRoot.showCoreHighlight null
