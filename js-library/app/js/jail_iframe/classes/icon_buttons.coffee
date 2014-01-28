updateIconButtons = ->
  FactlinkJailRoot.trigger 'updateIconButtons'

FactlinkJailRoot.core_loaded_promise.then ->
  $(window).on 'resize', updateIconButtons
  setInterval updateIconButtons, 1000
  FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', updateIconButtons


class FactlinkJailRoot.ShowButton
  content: '<div class="fl-icon-button"><span class="icon-comment"></span></div>'

  constructor: (highlightElements, factId) ->
    @frame = new FactlinkJailRoot.ControlIframe @content
    $el = $(@frame.frameBody.firstChild)

    @$highlightElements = $(highlightElements)
    @_factId = factId

    @_robustHover = new FactlinkJailRoot.RobustHover
      $el: $el
      $externalDocument: $(document)
      mouseenter: @_onHover
      mouseleave: @_onUnhover
    $el.on 'click', @_onClick

    @$highlightElements.on 'mouseenter', @_onHover
    @$highlightElements.on 'mouseleave', @_onUnhover
    @$highlightElements.on 'click', @_onClick

    @frame.fadeIn()
    FactlinkJailRoot.on 'updateIconButtons', @_updatePosition
    @_updatePosition()

  destroy: ->
    @$boundingBox?.remove()
    @_robustHover.destroy()
    @$highlightElements.off 'mouseenter', @_onHover
    @$highlightElements.off 'mouseleave', @_onUnhover
    @$highlightElements.off 'click', @_onClick
    @frame.destroy()
    FactlinkJailRoot.off 'updateIconButtons', @_updatePosition

  _onHover: =>
    @frame.addClass 'hovered'
    @$highlightElements.addClass 'fl-active'

  _onUnhover: =>
    @frame.removeClass 'hovered'
    @$highlightElements.removeClass 'fl-active'

  _onClick: =>
    FactlinkJailRoot.openFactlinkModal @_factId

  _textContainer: (el) ->
    for el in $(el).parents()
      return el if window.getComputedStyle(el).display == 'block'
    console.error 'FactlinkJailRoot: No text container found for ', el

  _updatePosition: =>
    textContainer = @_textContainer(@$highlightElements[0])
    contentBox = FactlinkJailRoot.contentBox(textContainer)

    left = contentBox.left + contentBox.width
    left = Math.min left, $(window).width() - @frame.$el.outerWidth()

    @frame.setOffset
      top: @$highlightElements.first().offset().top
      left: left

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'red'


class ParagraphButton
  content: '<div class="fl-icon-button"><span class="icon-comment"></span>+</div>'

  constructor: (paragraphElement) ->
    @frame = new FactlinkJailRoot.ControlIframe @content
    $el = $(@frame.frameBody.firstChild)

    @_robustFrameHover = new FactlinkJailRoot.RobustHover
      $el: $el
      $externalDocument: $(document)
      mouseenter: => @frame.addClass 'hovered'
      mouseleave: => @frame.removeClass 'hovered'
    $el.on 'click', @_onClick

    @$paragraph = $(paragraphElement)
    @frame.fadeIn()
    FactlinkJailRoot.on 'updateIconButtons', @_update
    @_update()

  destroy: ->
    @$boundingBox?.remove()
    @_robustHover.destroy()
    @frame.destroy()
    FactlinkJailRoot.off 'updateIconButtons', @_update

  _update: =>
    if @_valid()
      @_updatePosition()
    else
      @destroy()

  _valid: =>
    @$paragraph.find('.factlink').length <= 0 && @$paragraph.is(':visible')

  _updatePosition: ->
    contentBox = FactlinkJailRoot.contentBox(@$paragraph[0])

    @frame.setOffset
      top: contentBox.top
      left: contentBox.left + contentBox.width

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'green'

  _onClick: =>
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

    textLength = $clonedEl.text().replace(/\s+/g, ' ').trim().length
    $clonedEl.remove()

    textLength >= 50

  _addParagraphButton: (el) ->
    return unless @_paragraphHasContent(el)

    @_paragraphButtons.push new ParagraphButton el

  _addParagraphButtonsBatch: (elements) ->
    for el in elements[0...10]
      @_addParagraphButton el

    elementsLeft = elements[10..]
    setTimeout (=> @_addParagraphButtonsBatch(elementsLeft)), 200

  addParagraphButtons: ->
    return unless FactlinkJailRoot.can_haz.paragraph_icons

    for paragraphButton in @_paragraphButtons
      paragraphButton.destroy()

    @_addParagraphButtonsBatch $('p, h2, h3, h4, h5, h6, li')

FactlinkJailRoot.core_loaded_promise.then ->
  paragraphButtons = new FactlinkJailRoot.ParagraphButtons
  paragraphButtons.addParagraphButtons()
