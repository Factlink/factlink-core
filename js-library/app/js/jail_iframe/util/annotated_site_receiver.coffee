# Object which holds the methods that can be called from the factlink core iframe

FactlinkJailRoot.annotatedSiteReceiver =
  modalFrameReady: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    window.FACTLINK_ON_CORE_LOAD?()

  openModalOverlay: ->
    $("#factlink-modal-frame").fadeIn 'fast'
    console.log 'fadeIn', $("#factlink-modal-frame")[0]
    FactlinkJailRoot.trigger 'modalOpened'

  highlightNewFactlink: (displaystring, id) ->
    FactlinkJailRoot.selectRanges(FactlinkJailRoot.search(displaystring), id)
    FactlinkJailRoot.trigger 'factlinkAdded'

  closeModal_noAction: ->
    $("#factlink-modal-frame").fadeOut 'fast', -> FactlinkJailRoot.trigger 'modalClosed'

  # For compatibility, please remove the next time you see this
  closeModal_highlightNewFactlink: (displaystring, id) ->
    @highlightNewFactlink(displaystring, id)
    @closeModal_noAction()

  closeModal_deleteFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()
    @closeModal_noAction()
