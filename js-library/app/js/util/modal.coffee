# The iFrame which holds the intermediate
iFrame = $('<div />').attr
  id: 'factlink-modal-frame'

iFrame.hide()
iFrame.appendTo(Factlink.el)

Factlink.hideDimmer = -> iFrame.css 'background', 'none'

Factlink.showInfo = (factId, successCallback = ->) ->
  Factlink.remote.showFactlink factId, ->
    Factlink.modal.show.method()
    Factlink.trigger('modalOpened')

    successCallback()

clickHandler = -> Factlink.modal.hide.method()

bindClick = -> $(document).bind 'click', clickHandler

unbindClick = -> $(document).unbind 'click', clickHandler

# Object which holds the methods that can be called from the intermediate iframe
# These methods are also used by the internal scripts and can be called through
# Factlink.modal.FUNCTION.method() because easyXDM changes the object structure
Factlink.modal =
  hide: ->
    unbindClick()
    iFrame.fadeOut 'fast'
    $('html').removeClass ('fl-modal-open')

    Factlink.trigger 'modalClosed'

  show: ->
    bindClick()
    iFrame.fadeIn('fast')
    $('html').addClass ('fl-modal-open')

  highlightNewFactlink: (fact, id) ->
    fct = Factlink.selectRanges(Factlink.search(fact), id)

    _.extend Factlink.Facts, fct

    Factlink.trigger 'factlinkAdded'

    Factlink.modal.hide.method()

    Factlink.Views.Notifications.showFactlinkCreated()

    fct

  stopHighlightingFactlink: (id) ->
    $("span.factlink[data-factid=#{id}]").each (i, val) ->
      $(val).contents().unwrap()

  trigger: (e) -> Factlink.trigger(e)
