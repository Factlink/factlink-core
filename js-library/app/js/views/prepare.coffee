Factlink.Prepare = ->

  el = null
  factId = null
  facts = null
  loading = false

  el = $(Factlink.templates.create)
  el.appendTo Factlink.el
  el.hide()
  el.bind "mouseup", (e) -> e.stopPropagation()
  el.bind "mousedown", (e) -> e.preventDefault()
  el.bind "click", (e) =>
    e.preventDefault()
    e.stopPropagation()
    @startLoading()
    Factlink.createFactFromSelection()

  el.delegate ".fl-created", "click", (e) =>
    if facts.length > 0
      facts[0].click()
      @hide 100

  @show = (top, left) =>
    @resetType()
    Factlink.set_position_of_element top, left, window, el
    el.fadeIn "fast"

  @hide = (callback) =>
    el.fadeOut "fast", =>
      @stopLoading() if loading
      callback?()

  @startLoading = ->
    loading = true
    el.addClass "fl-loading"

  @stopLoading = ->
    loading = false
    @hide ->
      el.removeClass "fl-loading"

  @isVisible = ->
    el.is ":visible"

  @setFactId = (id) ->
    factId = id

  @resetFactId = ->
    factId = null

  @getFactId = ->
    factId

  types = ["fl-create", "fl-created"]

  @setType = (str) ->
    el.removeClass(types.join(" ")).addClass str

  @resetType = =>
    el.removeClass(types.join(" ")).addClass types[0]
    el.removeClass "right left"
    facts = []
    @resetFactId()

  return this
