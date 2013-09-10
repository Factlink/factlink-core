class Button
  constructor: (dom_events={}) ->
    @$el = $(@template)
    @$el.appendTo(Factlink.el)
    for event, callback of dom_events
      @$el.bind event, callback

  startLoading: -> @$el.addClass    "fl-loading"
  stopLoading:  -> @$el.removeClass "fl-loading"
  isLoading:    -> @$el.hasClass    "fl-loading"

  show: (top, left) =>
    @stopLoading() if @isLoading()
    Factlink.el.find('div.fl-popup').removeClass('active')
    Factlink.set_position_of_element top, left, window, @$el
    @$el.addClass 'active'

  hide: -> @$el.removeClass 'active'

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
