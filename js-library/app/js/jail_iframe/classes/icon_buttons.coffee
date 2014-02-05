updateIconButtons = ->
  FactlinkJailRoot.trigger 'updateIconButtons'

iconButtonMargin = 5 #keep in sync with _ icon_buttons.scss

FactlinkJailRoot.host_ready_promise.then ->
  $(window).on 'resize', updateIconButtons
  setInterval updateIconButtons, 1000
  FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', updateIconButtons


class FactlinkJailRoot.ShowButton
  content: '<factlink-show-button><span class="icon-comment"></span></factlink-show-button>'

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

    @frame.fadeIn()
    FactlinkJailRoot.on 'updateIconButtons', @_updatePosition
    @_updatePosition()

  destroy: ->
    @$boundingBox?.remove()
    @_robustHover.destroy()
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
      top: @$highlightElements.first().offset().top - iconButtonMargin
      left: left - iconButtonMargin

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'red'


class FactlinkJailRoot.ParagraphButton
  constructor: (paragraphElement) ->
    @$paragraph = $(paragraphElement)
    return unless @_valid()

    @$el = $('<factlink-paragraph-button></factlink-paragraph-button>')
    FactlinkJailRoot.$factlinkCoreContainer.append(@$el)

    @_attentionSpan = new FactlinkJailRoot.AttentionSpan
      wait_for_neglection: 500
      onAttentionGained: => @$el.show()
      onAttentionLost: => @$el.hide()

    @_robustFrameHover = new FactlinkJailRoot.RobustHover
      $el: @$el
      mouseenter: => @_attentionSpan.gainAttention()
      mouseleave: => @_attentionSpan.loseAttention()
    @$el.on 'click', @_onClick

    FactlinkJailRoot.on 'updateIconButtons', @_update
    @_updatePosition()

    unless FactlinkJailRoot.isTouchDevice()
      @$el.hide()
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
    @$el.remove()
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
    containerOffset = FactlinkJailRoot.$factlinkCoreContainer.offset()

    @$el.css
      top: (contentBox.top - iconButtonMargin - containerOffset.top) + 'px'
      left: (contentBox.left + contentBox.width - iconButtonMargin - containerOffset.left) + 'px'

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      @$boundingBox?.remove()
      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'green'

  _textFromElement: (element) ->
    selection = document.getSelection()
    selection.removeAllRanges()

    range = document.createRange()
    range.setStart element, 0
    range.setEndAfter element

    selection.addRange(range)
    text = selection.toString()
    selection.removeAllRanges()

    text.trim()

  _onClick: =>
    text = @_textFromElement @$paragraph[0]
    siteTitle = document.title
    siteUrl = FactlinkJailRoot.siteUrl()

    FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink',
      text, siteUrl, siteTitle, null
