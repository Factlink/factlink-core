class Button
  constructor: (dom_events={}) ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el =  $(@frame.doc.body.firstChild)
    for event, callback of dom_events
      @$el.on event, callback

  startLoading: => @$el.addClass "fl-button-loading"
  stopLoading:  => @$el.removeClass  "fl-button-loading"

  setCoordinates: (top, left) =>
    @_top = top
    @_left = left

  show: =>
    @stopLoading()
    FactlinkJailRoot.set_position_of_element @_top, @_left, window, @frame.$el
    @frame.fadeIn()

  hide: => @frame.fadeOut()

  destroy: => @frame.destroy()

class FactlinkJailRoot.ShowButton extends Button
  content: """
    <div class="fl-button">
      <span class="fl-button-default-content">Show Annotation</span>
      <span class="fl-button-loading-content">Loading...</span>
    </div>
  """


class FactlinkJailRoot.CreateButton extends Button
  content: """
    <div class="fl-button">
      <span class="fl-button-default-content">Add Annotation</span>
      <span class="fl-button-loading-content">Loading...</span>
    </div>
  """
