class Factlink.Prepare

  constructor: ->
    @$el = $(Factlink.templates.create)
    @$el.appendTo Factlink.el
    @$el.hide()

    @$el.bind "mouseup", (e) -> e.stopPropagation()
    @$el.bind "mousedown", (e) -> e.preventDefault()
    @$el.bind "click", (e) =>
      e.preventDefault()
      e.stopPropagation()
      @startLoading()
      Factlink.createFactFromSelection()

  show: (top, left) =>
    Factlink.set_position_of_element top, left, window, @$el
    @$el.fadeIn "fast"

  hide: (callback) =>
    @$el.fadeOut "fast", =>
      @stopLoading() if @_loading
      callback?()

  startLoading: ->
    @_loading = true
    @$el.addClass "fl-loading"

  stopLoading: ->
    @_loading = false
    @hide => @$el.removeClass "fl-loading"

  isVisible: ->
    @$el.is ":visible"
