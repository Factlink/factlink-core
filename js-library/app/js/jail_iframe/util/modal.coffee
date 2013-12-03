# The iFrame which holds the intermediate
iFrame = $('<div />').attr
  id: 'factlink-modal-frame'

iFrame.hide()
iFrame.appendTo(FactlinkJailRoot.el)

FactlinkJailRoot.hideDimmer = -> iFrame.css 'background', 'none'

FactlinkJailRoot.openFactlinkModal = (id) -> FactlinkJailRoot.remote.showFactlink id #TODO: xdmcleanup

suppressScrollbars = ->
  if FactlinkJailRoot.can_haz.suppress_double_scrollbar
    document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')
restoreScrollbars = -> document.documentElement.removeAttribute('data-factlink-suppress-scrolling')

# Object which holds the methods that can be called from the intermediate iframe
# These methods are also used by the internal scripts and can be called through
# FactlinkJailRoot.modal.FUNCTION.method() because easyXDM changes the object structure
FactlinkJailRoot.modal =
  hide: ->
    iFrame.fadeOut 'fast', -> restoreScrollbars()
    FactlinkJailRoot.trigger 'modalClosed'

  onModalReady: ->
    suppressScrollbars()
    iFrame.fadeIn('fast')
    FactlinkJailRoot.trigger 'modalOpened'

  highlightNewFactlink: (fact, id) ->
    fct = FactlinkJailRoot.selectRanges(FactlinkJailRoot.search(fact), id)
    FactlinkJailRoot.trigger 'factlinkAdded'

    FactlinkJailRoot.modal.hide()

    FactlinkJailRoot.showFactlinkCreatedNotification()

  stopHighlightingFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()


  setFeatureToggles: (featureToggles) ->
    FactlinkJailRoot.can_haz = featureToggles
    window.FACTLINK_ON_CORE_LOAD?()
