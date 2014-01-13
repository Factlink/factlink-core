# Buttons in iframes sometimes don't trigger mouseleave, hence check
# document for mousemove to be sure.
class RobustHover
  constructor: (@$el, @_callbacks) ->
    @$el.on 'mouseenter', @_onMouseEnter
    @$el.on 'mouseleave', @_onMouseLeave

  destroy: ->
    @$el.off 'mouseenter', @_onMouseEnter
    @$el.off 'mouseleave', @_onMouseLeave
    $(document).off 'mousemove', @_onMouseLeave

  _onMouseEnter: =>
    $(document).on 'mousemove', @_onMouseLeave
    @_callbacks.mouseenter?()

  _onMouseLeave: =>
    $(document).off 'mousemove', @_onMouseLeave
    @_callbacks.mouseleave?()

class Button
  constructor: ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el = $(@frame.frameBody.firstChild)

  _bindCallbacks: (callbacks={}) ->
    @_robustHover = new RobustHover @$el, callbacks
    @$el.on 'click', -> callbacks.click?()

  startLoading: => @_addClass 'fl-button-state-loading'
  stopLoading: => @_removeClass 'fl-button-state-loading fl-button-state-hovered'

  startHovering: => @_addClass 'fl-button-state-hovered'
  stopHovering: => @_removeClass 'fl-button-state-hovered'

  _addClass: (classes) =>
    @$el.addClass classes
    @frame.sizeFrameToFitContent()
    @_updatePosition()

  _removeClass: (classes) =>
    @$el.removeClass classes
    @frame.sizeFrameToFitContent()
    @_updatePosition()

  _fadeIn: ->
    return if @_visible

    @_visible = true
    @frame.fadeIn()

  _showAtCoordinates: (top, left) =>
    containerOffset = FactlinkJailRoot.$factlinkCoreContainer.offset()
    left -= containerOffset.left
    top -= containerOffset.top

    @frame.$el.css
      left: left + "px"
      top: top + "px"

  hide: =>
    @frame.fadeOut()
    @_visible = false

  destroy: =>
    @frame.destroy()
    @_robustHover.destroy()

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

  constructor: (options) ->
    super

    @_bindCallbacks options.callbacks

    @$nearEl = $(options.el)
    @_fadeIn()
    @_updatePosition()

    $(window).on 'resize', => @_updatePosition()
    setInterval (=> @_updatePosition()), 1000

    # remove when removing client_buttons feature toggle
    unless FactlinkJailRoot.can_haz.client_buttons
      @$el.addClass 'fl-button-hide-default'

  _isDisplayBlock: (el) ->
    # For some reason jQuery in FF sometimes returns "undefined"
    # Seems to be this one: https://stackoverflow.com/questions/14466604/jquery-returning-undefined-css-display
    displayValue = $(el).css('display') || window.getComputedStyle(el).display

    displayValue == 'block'

  _textContainer: ($el) ->
    for el in $el.parents()
      return el if @_isDisplayBlock(el)
    console.error 'FactlinkJailRoot: No text container found for ', $el

  _updatePosition: ->
    top = @$nearEl.offset().top + @$nearEl.outerHeight()/2 - @frame.$el.outerHeight()/2

    textContainer = @_textContainer(@$nearEl)
    range = document.createRange()
    range.setStartBefore textContainer
    range.setEndAfter textContainer
    selectionBox = range.getBoundingClientRect()
    selectionLeft = selectionBox.left + $(window).scrollLeft()

    left = selectionLeft + selectionBox.width
    left = Math.min left, $(window).width() - @frame.$el.outerWidth()

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

    @_bindCallbacks
      mouseenter: => @startHovering()
      mouseleave: => @stopHovering()

    @$el.on 'mousedown', (event) -> event.preventDefault() # To prevent de-selecting text
    @$el.on 'click', @_onClick

  _onClick: (event) =>
    @startLoading()
    current_user_opinion = $(event.target).data('opinion')
    FactlinkJailRoot.createFactFromSelection(current_user_opinion)

  _updatePosition: ->

  placeNearSelection: (mouseX=null) ->
    return if @_visible

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

    @_fadeIn()
    @_showAtCoordinates top, left
