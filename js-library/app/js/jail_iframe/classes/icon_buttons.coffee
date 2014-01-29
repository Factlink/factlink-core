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


class FactlinkJailRoot.ParagraphButton
  content: '<div class="fl-icon-button"><span class="icon-comment"></span>+</div>'

  constructor: (paragraphElement) ->
    @frame = new FactlinkJailRoot.ControlIframe @content
    $el = $(@frame.frameBody.firstChild)

    @_attentionSpan = new FactlinkJailRoot.AttentionSpan
      wait_for_neglection: 500
      onAttentionGained: => @frame.fadeIn()
      onAttentionLost: => @frame.fadeOut()

    @_robustFrameHover = new FactlinkJailRoot.RobustHover
      $el: $el
      $externalDocument: $(document)
      mouseenter: => @frame.addClass 'hovered'; @_attentionSpan.gainAttention()
      mouseleave: => @frame.removeClass 'hovered'; @_attentionSpan.loseAttention()
    $el.on 'click', @_onClick

    @$paragraph = $(paragraphElement)
    FactlinkJailRoot.on 'updateIconButtons', @_update
    @_update()

    if FactlinkJailRoot.isTouchDevice()
      @frame.fadeIn()
    else
      @_robustParagraphHover = new FactlinkJailRoot.RobustHover
        $el: @$paragraph
        mouseenter: => @_showOnlyThisParagraphButton()
        mouseleave: => @_attentionSpan.loseAttention()
      FactlinkJailRoot.on 'hideAllParagraphButtons', @_onHideAllParagraphButtons

  _showOnlyThisParagraphButton: =>
    FactlinkJailRoot.trigger 'hideAllParagraphButtons'
    @_attentionSpan.gainAttention()

  _onHideAllParagraphButtons: =>
    @_attentionSpan.loseAttentionNow()

  destroy: ->
    @$boundingBox?.remove()
    @_robustFrameHover.destroy()
    @_attentionSpan.destroy()
    @_robustParagraphHover?.destroy()
    @frame.destroy()
    FactlinkJailRoot.off 'updateIconButtons', @_update
    @$paragraph.off 'mousemove', @_showOnlyThisParagraphButton
    FactlinkJailRoot.off 'hideAllParagraphButtons', @_onHideAllParagraphButtons

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
