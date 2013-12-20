# Object which holds the methods that can be called from the factlink core iframe

modalOpen = false

FactlinkJailRoot.annotatedSiteReceiver =
  modalFrameReady: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    window.FACTLINK_ON_CORE_LOAD?()

  openModalOverlay: ->
    return if modalOpen
    FactlinkJailRoot.$modalFrame.addClass 'factlink-control-visible'
    modalOpen = true
    FactlinkJailRoot.trigger 'modalOpened'

  highlightNewFactlink: (displaystring, id) ->
    FactlinkJailRoot.selectRanges(FactlinkJailRoot.search(displaystring), id)
    FactlinkJailRoot.trigger 'factlinkAdded'

  closeModal_noAction: ->
    FactlinkJailRoot.$modalFrame.removeClass 'factlink-control-visible'
    setTimeout( ->
      return unless modalOpen
      modalOpen = true
      FactlinkJailRoot.trigger 'modalClosed'
    , 300)

  # For compatibility, please remove the next time you see this
  closeModal_highlightNewFactlink: (displaystring, id) ->
    @highlightNewFactlink(displaystring, id)
    @closeModal_noAction()

  closeModal_deleteFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()
    @closeModal_noAction()
