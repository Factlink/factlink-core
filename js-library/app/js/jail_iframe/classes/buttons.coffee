class Button
  constructor: (dom_events={}) ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el =  $(@frame.frameBody.firstChild)
    for event, callback of dom_events
      @$el.on event, callback

  startLoading: => @$el.addClass "fl-button-loading"
  stopLoading:  => @$el.removeClass  "fl-button-loading"

  setCoordinates: (top, left) =>
    @_top = top
    @_left = left

  show: =>
    @stopLoading()
    @frame.fadeIn()

    left = @_left - @frame.$el.outerWidth(true)/2
    top = @_top - @frame.$el.outerHeight(true)

    @frame.$el.css
      left: left + "px"
      top: top + "px"

  hide: => @frame.fadeOut()

  destroy: => @frame.destroy()

class FactlinkJailRoot.ShowButton extends Button
  content: """
    <div class="fl-button">
      <div class="fl-button-default-content">Show Discussion</div>
      <div class="fl-button-loading-content">Loading...</div>
    </div>
  """


class FactlinkJailRoot.CreateButton extends Button
  content: """
    <div class="fl-button">
      <div class="fl-button-default-content">Create Discussion</div>
      <div class="fl-button-loading-content">Loading...</div>
    </div>
  """

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
