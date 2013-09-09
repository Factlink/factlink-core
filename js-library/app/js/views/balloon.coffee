class Factlink.Balloon
  constructor: (fact) ->
    @_fact = fact

    @$el = $(Factlink.templates.indicator)
    @$el.appendTo(Factlink.el)
    @$el.bind "mouseenter", => @_fact.focus()
    @$el.bind "mouseleave", => @_fact.blur()
    @$el.bind "click", => @_fact.click()

  hideAll: ->
    Factlink.el.find('div.fl-popup').hide()

  show: (top, left, fast) ->
    window.clearTimeout @_mouseOutTimeoutID
    if fast
      @actualShow()
    else
      @_mouseOutTimeoutID = window.setTimeout (=> @actualShow()), 200

    Factlink.set_position_of_element top, left, window, @$el

  actualShow: ->
    @hideAll()
    @$el.show()

  hide: (callback) ->
    window.clearTimeout @_mouseOutTimeoutID
    @$el.fadeOut "fast", callback
    @_fact.stopHighlighting()

  isVisible: ->
    @$el.is ":visible"

  destroy: ->
    @$el.remove()

  startLoading: ->
    @_loading = true
    @_loadingTimeoutID = setTimeout (=> @stopLoading()), 17000
    @$el.addClass "fl-loading"

  stopLoading: ->
    window.clearTimeout @_loadingTimeoutID
    @_loading = false
    @hide => @$el.removeClass "fl-loading"

  loading: -> !!@_loading
