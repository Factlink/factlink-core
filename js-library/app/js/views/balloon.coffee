class Factlink.Balloon
  constructor: (fact) ->
    @_fact = fact

    @$el = $(Factlink.templates.indicator)
    @$el.appendTo(Factlink.el)
    @$el.bind "mouseenter", => @_fact.focus()
    @$el.bind "mouseleave", => @_fact.blur()
    @$el.bind "click", => @_fact.click()

  _hideAll: -> Factlink.el.find('div.fl-popup').hide()

  show: (top, left) ->
    window.clearTimeout @_mouseOutTimeoutID
    @_mouseOutTimeoutID = window.setTimeout (=> @actualShow()), 200
    Factlink.set_position_of_element top, left, window, @$el

  actualShow: ->
    @_hideAll()
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
    @$el.addClass "fl-loading"

  stopLoading: ->
    @_loading = false
    @hide => @$el.removeClass "fl-loading"

  loading: -> !!@_loading
