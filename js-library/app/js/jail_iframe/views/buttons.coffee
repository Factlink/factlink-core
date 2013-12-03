class Button
  constructor: (dom_events={}) ->
    @$el = $(@template)
    @$el.appendTo(FactlinkJailRoot.$factlinkCoreContainer)
    for event, callback of dom_events
      @$el.bind event, callback

  startLoading: => @$el.addClass    "fl-loading"
  stopLoading:  => @$el.removeClass "fl-loading"

  setCoordinates: (top, left) =>
    return if @$el.hasClass 'active'
    FactlinkJailRoot.set_position_of_element top, left, window, @$el

  show: =>
    @stopLoading()
    FactlinkJailRoot.$factlinkCoreContainer.find('div.fl-button').removeClass('active')
    @$el.addClass 'active been-active'

  hide: => @$el.removeClass 'active'

  destroy: => @$el.remove()


class FactlinkJailRoot.ShowButton extends Button
  template: """
    <div class="fl-button">
      <span class="fl-default-message">Show Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """

  setCoordinates: (top, left) =>
    return if @position_already_determined
    @position_already_determined = true
    super

class FactlinkJailRoot.CreateButton extends Button
  template: """
    <div class="fl-button">
      <span class="fl-default-message">Add Factlink</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """
