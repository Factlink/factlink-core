class Button
  constructor: (dom_events={}) ->
    @$el = $(@template)
    @$el.appendTo(Factlink.el)
    for event, callback of dom_events
      @$el.bind event, callback

  startLoading: ->
    @_loading = true
    @$el.addClass "fl-loading"

  stopLoading: ->
    @_loading = false
    @$el.removeClass "fl-loading"

  isLoading: -> @$el.hasClass "fl-loading"

  show: (top, left) =>
    @stopLoading() if @isLoading()
    Factlink.el.find('div.fl-popup').removeClass('active')
    @$el.addClass 'active'
    Factlink.set_position_of_element top, left, window, @$el

  hide: (callback) ->
    @$el.removeClass 'active'
    if callback
      setTimeout (=> callback(@)), 400 # keep in sync with css

  destroy: -> @$el.remove()


class Factlink.ShowButton extends Button
  template: """
    <div class="fl-popup">
      <span class="fl-default-message">Show Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """

class Factlink.CreateButton extends Button
  template: """
    <div class="fl-popup">
      <span class="fl-default-message">Add Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """

  constructor: ->
    super
      mouseup: (e) -> e.stopPropagation()
      mousedown: (e) -> e.preventDefault()
      click: (e) =>
        e.preventDefault()
        e.stopPropagation()
        @startLoading()
        Factlink.createFactFromSelection()
