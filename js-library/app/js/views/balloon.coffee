class Factlink.Balloon
  constructor: (fact) ->
    @_mouseOutTimeoutID = null
    @_loadingTimeoutID = null
    @_loading = false
    @_initializeTemplate()

  _initializeTemplate: ->
    @$el = $(Factlink.templates.indicator)
    @$el.appendTo(Factlink.el)
    @$el.bind "mouseenter", -> fact.focus()
    @$el.bind "mouseleave", -> fact.blur()
    @$el.bind "click", -> fact.click()

  _hideAll: ->
    @$el.closest("#fl").find(".fl-popup").hide()

  show: (top, left, fast) ->
    window.clearTimeout @_mouseOutTimeoutID
    if fast
      @_hideAll()
      @$el.show()
    else
      @_mouseOutTimeoutID = window.setTimeout (=> @_hideAll(); @$el.fadeIn "fast"), 200

    Factlink.set_position_of_element top, left, window, @$el

  hide: (callback) ->
    window.clearTimeout @_mouseOutTimeoutID
    @$el.fadeOut "fast", callback
    fact?.stopHighlighting()

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

  loading: -> @_loading
