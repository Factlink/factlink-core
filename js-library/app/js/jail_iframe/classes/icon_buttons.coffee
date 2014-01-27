class IconButton

  constructor: ->
    @frame = new FactlinkJailRoot.ControlIframe()
    @frame.setContent($.parseHTML(@content.trim())[0])
    @$el = $(@frame.frameBody.firstChild)

  destroy: =>
    @frame.destroy()
    @_robustHover.destroy()
    $(window).off 'resize', @_updatePosition
    clearInterval @_interval
    @$boundingBox?.remove()

  _bindCallbacks: (callbacks) ->
    @_robustHover = new FactlinkJailRoot.RobustHover @$el, callbacks
    @$el.on 'click', -> callbacks.click?()

  # TODO: do all updates of different buttons in one pass
  _updatePositionRegularly: ->
    $(window).on 'resize', @_updatePosition
    @_interval = setInterval @_updatePosition, 1000
    @_updatePosition()


class FactlinkJailRoot.ShowButton extends IconButton
  content: '<div class="fl-icon-button"><span class="icon-comment"></span></div>'

  constructor: (options) ->
    super

    @_bindCallbacks options.callbacks

    @$nearEl = $(options.el)
    @frame.fadeIn()
    @_updatePositionRegularly()

  startHovering: => @frame.addClass 'hovered'
  stopHovering: => @frame.removeClass 'hovered'

  _textContainer: (el) ->
    for el in $(el).parents()
      return el if window.getComputedStyle(el).display == 'block'
    console.error 'FactlinkJailRoot: No text container found for ', el

  _updatePosition: =>
    textContainer = @_textContainer(@$nearEl[0])
    contentBox = FactlinkJailRoot.contentBox(textContainer)

    left = contentBox.left + contentBox.width
    left = Math.min left, $(window).width() - @frame.$el.outerWidth()

    @frame.setOffset
      top: @$nearEl.offset().top
      left: left

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'red'


class ParagraphButton extends IconButton
  content: '<div class="fl-icon-button"><span class="icon-comment"></span>+</div>'

  constructor: (options) ->
    super

    @_bindCallbacks
      mouseenter: => @frame.addClass 'hovered'
      mouseleave: => @frame.removeClass 'hovered'
      click: => @_onClick()

    @$paragraph = $(options.el)

    @frame.fadeIn()
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

    @frame.setOffset
      top: contentBox.top
      left: contentBox.left + contentBox.width

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

FactlinkJailRoot.loaded_promise.then ->
  paragraphButtons = new FactlinkJailRoot.ParagraphButtons
  paragraphButtons.addParagraphButtons()
