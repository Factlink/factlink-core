class FACTLINK.Prepare

  constructor: ->
    @$el = $(FACTLINK.templates.create)
    @$el.appendTo FACTLINK.el
    @$el.hide()

    @$el.bind "mouseup", (e) -> e.stopPropagation()
    @$el.bind "mousedown", (e) -> e.preventDefault()
    @$el.bind "click", (e) =>
      e.preventDefault()
      e.stopPropagation()
      @startLoading()
      FACTLINK.createFactFromSelection()

  show: (top, left) =>
    FACTLINK.set_position_of_element top, left, window, @$el
    @$el.fadeIn "fast"

  hide: (callback=->) =>
    @$el.fadeOut "fast", =>
      @stopLoading() if @_loading
      callback()

  startLoading: ->
    @_loading = true
    @$el.addClass "fl-loading"

  stopLoading: ->
    @_loading = false
    @hide => @$el.removeClass "fl-loading"

  isVisible: ->
    @$el.is ":visible"
