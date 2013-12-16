# Object which holds the methods that can be called from the factlink core iframe

FactlinkJailRoot.annotatedSiteReceiver =
  modalFrameReady: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    window.FACTLINK_ON_CORE_LOAD?()

  openModalOverlay: ->
    $("#factlink-modal-frame").fadeIn 'fast'
    FactlinkJailRoot.trigger 'modalOpened'

  closeModal_noAction: ->
    $("#factlink-modal-frame").fadeOut 'fast', -> FactlinkJailRoot.trigger 'modalClosed'

  closeModal_highlightNewFactlink: (fact, id) ->
    FactlinkJailRoot.selectRanges(FactlinkJailRoot.search(fact), id)
    FactlinkJailRoot.trigger 'factlinkAdded'
    @closeModal_noAction()

  closeModal_deleteFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()
    @closeModal_noAction()

