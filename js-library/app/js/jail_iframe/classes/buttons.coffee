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

  placeNearSelection: (mouseX=null) ->
    selectionBox = window.document.getSelection().getRangeAt(0).getBoundingClientRect()
    top = selectionBox.top + $(window).scrollTop() - 2
    left = mouseX ? ($(window).scrollLeft() + selectionBox.left + selectionBox.width/2)

    @setCoordinates top, left
