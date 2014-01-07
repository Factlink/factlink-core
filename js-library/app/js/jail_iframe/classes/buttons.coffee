class Button
  constructor: (dom_events={}) ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el = $(@frame.frameBody.firstChild)
    @$el.on 'mouseenter', => @_addClass 'fl-button-state-hovered'

    for event, callback of dom_events
      @$el.on event, callback

  startLoading: => @_addClass 'fl-button-state-loading'
  stopLoading: => @_removeClass 'fl-button-state-loading'

  _addClass: (classes) =>
    @$el.addClass classes
    @frame.sizeFrameToFitContent()

  _removeClass: (classes) =>
    @$el.removeClass classes
    @frame.sizeFrameToFitContent()

  _showAtCoordinates: (top, left) =>
    return if @_visible

    @_visible = true
    @frame.fadeIn()

    containerOffset = FactlinkJailRoot.$factlinkCoreContainer.offset()
    left -= containerOffset.left
    top -= containerOffset.top

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
        <span class="fl-button-icon-white"></span>
        Show Discussion
      </div>
      <div class="fl-button-content-loading">Loading...</div>
    </div>
  """

  constructor: ->
    super
    @$el.on 'mouseleave', => @_removeClass 'fl-button-state-hovered'

  _textContainer: ($el) ->
    for el in $el.parents()
      return el if $(el).css('display') == 'block'

  placeNearElement: (el) ->
    $el = $(el)
    top = $el.offset().top + $el.outerHeight()/2 - @frame.$el.outerHeight()/2

    textContainer = @_textContainer($el)
    range = document.createRange()
    range.setStartBefore textContainer
    range.setEndAfter textContainer
    selectionBox = range.getBoundingClientRect()
    selectionLeft = selectionBox.left + $(window).scrollLeft()

    left = selectionLeft + selectionBox.width

    @_showAtCoordinates top, left


class FactlinkJailRoot.CreateButton extends Button
  content: """
    <div class="fl-button fl-button-black fl-button-with-arrow-down">
      <div class="fl-button-content-default">
        <span class="fl-button-icon-add"></span>
      </div>
      <div class="fl-button-content-hovered">
        <span class="fl-button-icon-add"></span>
        <span class="fl-button-sub-button" data-opinion="believes">Agree</span><span class="fl-button-sub-button" data-opinion="doubts">Unsure</span><span class="fl-button-sub-button" data-opinion="disbelieves">Disagree</span>
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
    current_user_opinion = $(event.target).data('opinion')
    FactlinkJailRoot.createFactFromSelection(current_user_opinion)

  placeNearSelection: (mouseX=null) ->
    selectionBox = window.document.getSelection().getRangeAt(0).getBoundingClientRect()
    selectionLeft = selectionBox.left + $(window).scrollLeft()
    selectionTop = selectionBox.top + $(window).scrollTop()
    buttonWidth = @frame.$el.outerWidth()

    if mouseX
      left = Math.min Math.max(mouseX, selectionLeft+buttonWidth/2),
        selectionLeft+selectionBox.width-buttonWidth/2
    else
      left = selectionLeft + selectionBox.width/2

    left -= buttonWidth/2
    top = selectionTop-2-@frame.$el.outerHeight()

    @_showAtCoordinates top, left
