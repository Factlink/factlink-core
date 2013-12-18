class Button
  constructor: (dom_events={}) ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.doc.body.innerHTML = @content
    el = @el=  @frame.doc.body.firstChild
    for event, callback of dom_events
      el.addEventListener event, callback
    @frame.resizeFrame()
    @$el = $(el)


  startLoading: => @$el.addClass "fl-loading"
  stopLoading:  => @$el.removeClass  "fl-loading"

  setCoordinates: (top, left) =>
#    return if @$el.hasClass 'active'
    console.log 'setting position'
    FactlinkJailRoot.set_position_of_element top, left, window, @frame.$el

  show: =>
    @stopLoading()
    console.log @el.className
    #TODO:what's this line do?
    #FactlinkJailRoot.$factlinkCoreContainer.find('div.fl-button').removeClass('active')
    @$el.addClass 'active been-active'
    @frame.$el.addClass 'factlink-frame-visible'
    console.log @el.className


  hide: =>
    @$el.removeClass 'active'
    @frame.$el.removeClass 'factlink-frame-visible'
    console.log 'hiding frame'


  destroy: =>
    @frame.destroy()
    console.log 'destroying frame'


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
