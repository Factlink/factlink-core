# Buttons in iframes sometimes don't trigger mouseleave, hence check
# document for mousemove to be sure.
class RobustHover
  constructor: (@$el, @_callbacks) ->
    @_hovered = false

    # Use mousemove instead of mouseenter since it is more reliable
    @$el.on 'mousemove', @_onMouseEnter
    @$el.on 'mouseleave', @_onMouseLeave

  destroy: ->
    @$el.off 'mousemove', @_onMouseEnter
    @$el.off 'mouseleave', @_onMouseLeave
    $(document).off 'mousemove', @_onMouseLeave

  _onMouseEnter: =>
    return if @_hovered

    # Mouse leaves when *external* document registers mousemove
    $(document).on 'mousemove', @_onMouseLeave

    @_hovered = true
    @_callbacks.mouseenter?()

  _onMouseLeave: =>
    return unless @_hovered

    $(document).off 'mousemove', @_onMouseLeave
    @_hovered = false
    @_callbacks.mouseleave?()

class Button
  constructor: ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el = $(@frame.frameBody.firstChild)

  _bindCallbacks: (callbacks) ->
    @_robustHover = new RobustHover @$el, callbacks
    @$el.on 'click', -> callbacks.click?()

  startLoading: => @_addClass 'loading'
  stopLoading: => @_removeClass 'loading hovered'

  startHovering: => @_addClass 'hovered'
  stopHovering: => @_removeClass 'hovered'

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

  # TODO: do all updates of different buttons in one pass
  _updatePositionRegularly: ->
    $(window).on 'resize', @_updatePosition
    @_interval = setInterval @_updatePosition, 1000
    @_updatePosition()

  _updatePosition: =>

  hide: =>
    @frame.fadeOut()
    @_visible = false

  destroy: =>
    @frame.destroy()
    @_robustHover.destroy()
    $(window).off 'resize', @_updatePosition
    clearInterval @_interval
    @$boundingBox?.remove()

class FactlinkJailRoot.ShowButton extends Button
  content: '<div class="fl-icon-button"><span class="icon-comment"></span></div>'

  constructor: (options) ->
    super

    @_bindCallbacks options.callbacks

    @$nearEl = $(options.el)
    @_fadeIn()
    @_updatePositionRegularly()

    # remove when removing client_buttons feature toggle
    unless FactlinkJailRoot.can_haz.client_buttons
      @$el.addClass 'fl-button-hide-default'

  _textContainer: (el) ->
    for el in $(el).parents()
      return el if window.getComputedStyle(el).display == 'block'
    console.error 'FactlinkJailRoot: No text container found for ', el

  _updatePosition: =>
    textContainer = @_textContainer(@$nearEl[0])
    contentBox = FactlinkJailRoot.contentBox(textContainer)

    left = contentBox.left + contentBox.width
    left = Math.min left, $(window).width() - @frame.$el.outerWidth()

    @_showAtCoordinates @$nearEl.offset().top, left

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'red'


class FactlinkJailRoot.CreateButton extends Button
  content: """
    <div class="fl-button fl-button-black fl-button-with-arrow-down">
      <div class="fl-button-content-default">
        <span class="icon-comment"></span>
      </div>
      <div class="fl-button-content-hovered">
        <span class="icon-comment"></span>
        <span class="fl-button-sub-button" data-opinion="believes"><span class="icon-smile"></span></span><span class="fl-button-sub-button" data-opinion="doubts"><span class="icon-meh"></span></span><span class="fl-button-sub-button" data-opinion="disbelieves"><span class="icon-frown"></span></span>
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


class ParagraphButton extends Button
  content: '<div class="fl-icon-button"><span class="icon-comment"></span>+</div>'

  constructor: (options) ->
    super

    @_bindCallbacks
      mouseenter: => @startHovering()
      mouseleave: => @stopHovering()
      click: => @_onClick()

    @$paragraph = $(options.el)

    @_fadeIn()
    @_updatePositionRegularly()

    FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', @_destroyIfContainsFactlink

  destroy: ->
    super
    FactlinkJailRoot.off 'factlink.factsLoaded factlinkAdded', @_destroyIfContainsFactlink

  _destroyIfContainsFactlink: =>
    if @$paragraph.find('.factlink').length > 0
      @destroy()

  _updatePosition: ->
    contentBox = FactlinkJailRoot.contentBox(@$paragraph[0])

    @_showAtCoordinates contentBox.top, contentBox.left + contentBox.width

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'green'

  _onClick: ->
    text = @$paragraph.text()
    siteTitle = window.document.title
    siteUrl = FactlinkJailRoot.siteUrl()

    FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink',
      text, siteUrl, siteTitle, null


class FactlinkJailRoot.ParagraphButtons

  constructor: ->
    @_paragraphButtons = []

  _paragraphHasContent: (el) ->
    $clonedEl = $(el).clone()
    $clonedEl.find('a').remove() # Strip links

    textLength = $clonedEl.text().length
    $clonedEl.remove()

    textLength >= 50

  _addParagraphButton: (el) ->
    return unless @_paragraphHasContent(el)

    @_paragraphButtons.push new ParagraphButton el: el

  addParagraphButtons: ->
    return unless FactlinkJailRoot.can_haz.paragraph_icons

    for paragraphButton in @_paragraphButtons
      paragraphButton.destroy()

    for el in $('p, h2, h3, h4, h5, h6')
      @_addParagraphButton el
