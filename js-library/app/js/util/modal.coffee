# The iFrame which holds the intermediate
iFrame = $('<div />').attr
  id: 'factlink-modal-frame'

iFrame.hide()
iFrame.appendTo(Factlink.el)

Factlink.hideDimmer = -> iFrame.css 'background', 'none'

Factlink.openFactlinkModal = (factId, successCallback = ->) ->
  Factlink.onLoaded 'intermediateFrameReady', ->
    Factlink.remote.showFactlink factId, ->
      Factlink.modal.show.method()
      Factlink.trigger('modalOpened')

      successCallback()

clickHandler = -> Factlink.modal.hide.method()

bindClick = -> $(document).bind 'click', clickHandler

unbindClick = -> $(document).unbind 'click', clickHandler


suppressScrollbars = ->
  if Factlink.can_haz.suppress_double_scrollbar
    document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')
restoreScrollbars = -> document.documentElement.removeAttribute('data-factlink-suppress-scrolling')

# Object which holds the methods that can be called from the intermediate iframe
# These methods are also used by the internal scripts and can be called through
# Factlink.modal.FUNCTION.method() because easyXDM changes the object structure
Factlink.modal =
  hide: ->
    unbindClick()
    iFrame.fadeOut 'fast', -> restoreScrollbars()
    Factlink.trigger 'modalClosed'

  show: ->
    suppressScrollbars()
    bindClick()
    iFrame.fadeIn('fast')

  highlightNewFactlink: (fact, id) ->
    fct = Factlink.selectRanges(Factlink.search(fact), id)

    $.extend Factlink.Facts, fct

    Factlink.trigger 'factlinkAdded'

    Factlink.modal.hide.method()

    Factlink.showFactlinkCreatedNotification()

    fct

  stopHighlightingFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()

  trigger: (e) -> Factlink.trigger(e)

  setFeatureToggles: (featureToggles) ->
    Factlink.can_haz = featureToggles
