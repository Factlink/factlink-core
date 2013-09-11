class Button
  constructor: (dom_events={}) ->
    @$el = $(@template)
    @$el.appendTo(Factlink.el)
    for event, callback of dom_events
      @$el.bind event, callback

  startLoading: => @$el.addClass    "fl-loading"
  stopLoading:  => @$el.removeClass "fl-loading"

  setCoordinates: (top, left) =>
    return if @$el.hasClass 'active'
    Factlink.set_position_of_element top, left, window, @$el

  show: =>
    @stopLoading()
    Factlink.el.find('div.fl-button').removeClass('active')
    @$el.addClass 'active'

  hide: => @$el.removeClass 'active'

  destroy: => @$el.remove()


class Factlink.ShowButton extends Button
  template: """
    <div class="fl-button fl-show-button">
      <span class="fl-default-message">Show Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """

  setCoordinates: (top, left) =>
    return if @position_already_determined
    @position_already_determined = true
    super

class Factlink.CreateButton extends Button
  template: """
    <div class="fl-button fl-create-button">
      <span class="fl-default-message">Add Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """
