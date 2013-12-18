class Button
  constructor: (dom_events={}) ->
    @$el = $(@content)
    @$el.appendTo(FactlinkJailRoot.$factlinkCoreContainer)
    for event, callback of dom_events
      @$el.bind event, callback

  startLoading: => @$el.addClass    "fl-loading"
  stopLoading:  => @$el.removeClass "fl-loading"

  setCoordinates: (top, left) =>
    return if @$el.hasClass 'active'
    FactlinkJailRoot.set_position_of_element top, left, window, @$el
    console.log 'setting position'

  show: =>
    @stopLoading()
    FactlinkJailRoot.$factlinkCoreContainer.find('div.fl-button').removeClass('active')
    console.log @el.className
    @$el.addClass 'active been-active'

  hide: => @$el.removeClass 'active'

  destroy: => @$el.remove()


class FactlinkJailRoot.ShowButton extends Button
  content: """
    <div class="fl-button">
      <span class="fl-default-message">Show Annotation</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """


class FactlinkJailRoot.CreateButton extends Button
  content: """
    <div class="fl-button">
      <span class="fl-default-message">Add Annotation</span>
      <span class="fl-loading-message">Loading...</span>
    </div>
  """
