# Object which holds the methods that can be called from the factlink core iframe

modalOpen = false

FactlinkJailRoot.annotatedSiteReceiver =
  modalFrameReady: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    window.FACTLINK_ON_CORE_LOAD?()

    (new FactlinkJailRoot.ParagraphIcons).addParagraphIcons()

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

  deleteFactlink: (id) ->
    for fact in FactlinkJailRoot.highlightsByFactIds[id]
      fact.destroy()
    delete FactlinkJailRoot.highlightsByFactIds[id]

  closeModal: ->
    if !modalOpen
      console.error 'trying to close an already closed modal: bug?'
      return
    modalOpen = false

    FactlinkJailRoot.trigger 'modalClosed'
    FactlinkJailRoot.$sidebarFrame.removeClass 'factlink-sidebar-frame-visible'

  # For compatibility, please remove the next time you see this
  closeModal_noAction: ->
    @closeModal()

  # For compatibility, please remove the next time you see this
  closeModal_highlightNewFactlink: (displaystring, id) ->
    @highlightNewFactlink(displaystring, id)
    @closeModal()

  # For compatibility, please remove the next time you see this
  closeModal_deleteFactlink: (id) ->
    @deleteFactlink(id)
