class Factlink.Balloon
  template: """
    <div class="fl-popup">
      <span class="fl-default-message">Show Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """

  constructor: (dom_events={}) ->
    @$el = $(@template)
    @$el.appendTo(Factlink.el)
    for event, callback of dom_events
      @$el.bind event, callback

  show: (top, left) ->
    Factlink.el.find('div.fl-popup').removeClass('active')
    @$el.addClass 'active'
    Factlink.set_position_of_element top, left, window, @$el

  hide: (callback) ->
    @$el.removeClass 'active'
    setTimeout (=> callback(@)), 400

  destroy: -> @$el.remove()

  startLoading: -> @$el.addClass "fl-loading"


class Factlink.Prepare
  template: """
    <div class="fl-popup">
      <span class="fl-default-message">Add Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """

  constructor: ->
    @$el = $(@template)
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
    @stopLoading() if @_loading
    Factlink.set_position_of_element top, left, window, @$el
    @$el.addClass 'active'

  hide: (callback=->) =>
    @$el.removeClass 'active'

  startLoading: ->
    @_loading = true
    @$el.addClass "fl-loading"

  stopLoading: ->
    @_loading = false
    @hide => @$el.removeClass "fl-loading"

  isVisible: ->
    @$el.is ":visible"
