# Object which holds the methods that can be called from the factlink core iframe

modalCloseTimeoutHandle = null

FactlinkJailRoot.annotatedSiteReceiver =
  modalFrameReady: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    window.FACTLINK_ON_CORE_LOAD?()

  openModalOverlay: ->
    console.log 'fadeIn', $("#factlink-modal-frame")[0]
    if modalCloseTimeoutHandle
      clearTimeout(modalCloseTimeoutHandle)
      modalCloseTimeoutHandle = null
    $("#factlink-modal-frame").addClass 'factlink-frame-visible'
    FactlinkJailRoot.trigger 'modalOpened'

  highlightNewFactlink: (displaystring, id) ->
    FactlinkJailRoot.selectRanges(FactlinkJailRoot.search(displaystring), id)
    FactlinkJailRoot.trigger 'factlinkAdded'

  closeModal_noAction: ->
    $("#factlink-modal-frame").removeClass 'factlink-frame-visible'
    modalCloseTimeoutHandle = setTimeout(-> FactlinkJailRoot.trigger 'modalClosed', 300)

  # For compatibility, please remove the next time you see this
  closeModal_highlightNewFactlink: (displaystring, id) ->
    @highlightNewFactlink(displaystring, id)
    @closeModal_noAction()

  closeModal_deleteFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()
    @closeModal_noAction()
