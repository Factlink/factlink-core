Factlink.Balloon = (factId, fact) ->
  el = null
  mouseOutTimeoutID = null
  loadingTimeoutID = null
  loading = false

  initializeTemplate = ->
    el = $(Factlink.templates.indicator)
    el.appendTo(Factlink.el)
    el.bind "mouseenter", -> fact.focus()
    el.bind "mouseleave", -> fact.blur()
    el.bind "click", -> fact.click()

  hideAll = ->
    el.closest("#fl").find(".fl-popup").hide()

  initializeTemplate()

  @show = (top, left, fast) ->
    window.clearTimeout mouseOutTimeoutID
    if fast
      hideAll()
      el.show()
    else
      mouseOutTimeoutID = window.setTimeout (-> hideAll(); el.fadeIn "fast"), 200

    Factlink.set_position_of_element top, left, window, el

  @hide = (callback) ->
    window.clearTimeout mouseOutTimeoutID
    el.fadeOut "fast", callback
    fact?.stopHighlighting()

  @isVisible = ->
    el.is ":visible"

  @destroy = ->
    el.remove()

  @startLoading = ->
    loading = true
    loadingTimeoutID = setTimeout (=> @stopLoading()), 17000
    el.addClass "fl-loading"

  @stopLoading = ->
    window.clearTimeout loadingTimeoutID
    loading = false
    @hide -> el.removeClass "fl-loading"

  @loading = -> loading

  return this
