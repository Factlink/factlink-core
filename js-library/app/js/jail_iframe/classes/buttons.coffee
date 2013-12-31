class Button
  constructor: (dom_events={}) ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el = $(@frame.frameBody.firstChild)
    @$el.on 'mouseenter', => @setStateClass 'fl-button-state-hovered'

    for event, callback of dom_events
      @$el.on event, callback

  startLoading: => @setStateClass 'fl-button-state-loading'

  setStateClass: (stateClass) =>
    @$el.removeClass "fl-button-state-loading fl-button-state-hovered"
    @$el.addClass stateClass
    @frame.sizeFrameToFitContent()

  setCoordinates: (top, left) =>
    return if @_visible

    @_top = top
    @_left = left

  show: =>
    return if @_visible

    @_visible = true
    @setStateClass ''
    @frame.fadeIn()

    left = @_left - @frame.$el.outerWidth(true)/2
    top = @_top - @frame.$el.outerHeight(true)

    @frame.$el.css
      left: left + "px"
      top: top + "px"

  hide: =>
    @frame.fadeOut()
    @_visible = false

  destroy: => @frame.destroy()

class FactlinkJailRoot.ShowButton extends Button
  content: """
    <div class="fl-button">
      <div class="fl-button-content-default">
        <span class="fl-button-icon"></span>
      </div>
      <div class="fl-button-content-hovered">
        <span class="fl-button-icon"></span>
        Show Discussion
      </div>
      <div class="fl-button-content-loading">Loading...</div>
    </div>
  """


class FactlinkJailRoot.CreateButton extends Button
  content: """
    <div class="fl-button">
      <div class="fl-button-content-default">
        <span class="fl-button-icon-add"></span>
      </div>
      <div class="fl-button-content-hovered">
        <span class="fl-button-icon-add"></span>
        <span class="fl-button-sub-button">Agree</span><span class="fl-button-sub-button">Unsure</span><span class="fl-button-sub-button">Disagree</span>
      </div>
      <div class="fl-button-content-loading">Loading...</div>
    </div>
  """

  constructor: ->
    super
    @$el.on 'mousedown', (event) -> event.preventDefault() # To prevent de-selecting text
    @$el.on 'click', @_onClick

  _onClick: (event) =>
    @startLoading()
    FactlinkJailRoot.createFactFromSelection()

  placeNearSelection: (mouseX=null) ->
    selectionBox = window.document.getSelection().getRangeAt(0).getBoundingClientRect()
    selectionLeft = selectionBox.left + $(window).scrollLeft()
    selectionTop = selectionBox.top + $(window).scrollTop()
    buttonWidth = @frame.$el.outerWidth(true)

    if mouseX
      left = Math.min Math.max(mouseX, selectionLeft+buttonWidth/2),
        selectionLeft+selectionBox.width-buttonWidth/2
    else
      left = selectionLeft + selectionBox.width/2

    @setCoordinates selectionTop-2, left
