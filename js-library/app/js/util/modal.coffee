# The iFrame which holds the intermediate
iFrame = $('<div />').attr
  id: 'factlink-modal-frame'

iFrame.hide()
iFrame.appendTo(FACTLINK.el)

FACTLINK.hideDimmer = -> iFrame.css 'background', 'none'

FACTLINK.showInfo = (factId, successCallback = ->) ->
  FACTLINK.remote.showFactlink factId, ->
    FACTLINK.modal.show.method()
    FACTLINK.trigger('modalOpened')

    successCallback()

clickHandler = -> FACTLINK.modal.hide.method()

bindClick = -> $(document).bind 'click', clickHandler

unbindClick = -> $(document).unbind 'click', clickHandler

# Object which holds the methods that can be called from the intermediate iframe
# These methods are also used by the internal scripts and can be called through
# FACTLINK.modal.FUNCTION.method() because easyXDM changes the object structure
FACTLINK.modal =
  hide: ->
    unbindClick()
    iFrame.fadeOut 'fast'
    FACTLINK.trigger 'modalClosed'

  show: ->
    bindClick()
    iFrame.fadeIn('fast')

  highlightNewFactlink: (fact, id) ->
    fct = FACTLINK.selectRanges(FACTLINK.search(fact), id)

    $.extend FACTLINK.Facts, fct

    FACTLINK.trigger 'factlinkAdded'

    FACTLINK.modal.hide.method()

    FACTLINK.Views.Notifications.showFactlinkCreated()

    fct

  stopHighlightingFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()

  trigger: (e) -> FACTLINK.trigger(e)
