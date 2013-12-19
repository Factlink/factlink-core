class Button
  constructor: (dom_events={}) ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content))
    @$el =  $(@frame.doc.body.firstChild)
    for event, callback of dom_events
      @$el.on event, callback

  startLoading: => @$el.addClass "fl-loading"
  stopLoading:  => @$el.removeClass  "fl-loading"

  setCoordinates: (top, left) =>
    @_top = top
    @_left = left

  show: =>
    @stopLoading()
    FactlinkJailRoot.set_position_of_element @_top, @_left, window, @frame.$el
    #TODO:what's this line do?
    #FactlinkJailRoot.$factlinkCoreContainer.find('div.fl-button').removeClass('active')
    @$el.addClass 'active'
    @frame.$el.addClass 'factlink-control-visible'

  hide: =>
    @$el.removeClass 'active'
    @frame.$el.removeClass 'factlink-control-visible'

  destroy: =>
    @frame.destroy()

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
