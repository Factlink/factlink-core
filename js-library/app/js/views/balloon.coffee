class Factlink.Balloon
  constructor: (fact) ->
    @_fact = fact

    @$el = $(Factlink.templates.indicator)
    @$el.appendTo(Factlink.el)
    @$el.bind "mouseenter", => @_fact.focus()
    @$el.bind "mouseleave", => @_fact.blur()
    @$el.bind "click", => @_fact.click()

  show: (top, left) ->
    Factlink.el.find('div.fl-popup').hide()
    @$el.show()
    Factlink.set_position_of_element top, left, window, @$el

  hide: (callback) -> @$el.fadeOut "fast", callback

  destroy: -> @$el.remove()

  startLoading: ->
    @_loading = true
    @$el.addClass "fl-loading"

  loading: -> !!@_loading
