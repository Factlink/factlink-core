updateIconButtons = ->
  FactlinkJailRoot.trigger 'updateIconButtons'

FactlinkJailRoot.host_ready_promise.then ->
  $(window).on 'resize', updateIconButtons
  setInterval updateIconButtons, 1000
  FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', updateIconButtons


class FactlinkJailRoot.ShowButton
  constructor: (highlightElements, factId) ->
    @$el = $('<factlink-show-button></factlink-show-button>')
    FactlinkJailRoot.$factlinkCoreContainer.append(@$el)

    @$highlightElements = $(highlightElements)
    @_factId = factId

    @_robustHover = new FactlinkJailRoot.RobustHover
      $el: @$el
      mouseenter: @_onHover
      mouseleave: @_onUnhover
    @$el.on 'click', @_onClick

    @$el.addClass 'factlink-control-visible'

    @_tether = new Tether
      element: @$el[0]
      target: @_textContainer(@$highlightElements[0])
      attachment: 'top left'
      targetAttachment: 'top right'

  destroy: ->
    @_tether.destroy()
    @_robustHover.destroy()
    @$el.remove()

  _onHover: =>
    @$highlightElements.addClass 'fl-active'

  _onUnhover: =>
    @$highlightElements.removeClass 'fl-active'

  _onClick: =>
    FactlinkJailRoot.openFactlinkModal @_factId

  _textContainer: (el) ->
    for el in $(el).parents()
      return el if window.getComputedStyle(el).display == 'block'
    console.error 'FactlinkJailRoot: No text container found for ', el

class FactlinkJailRoot.ParagraphButton
  constructor: (paragraphElement) ->
    @$paragraph = $(paragraphElement)
    return unless @_valid()

    @$el = $('<factlink-paragraph-button></factlink-paragraph-button>')
    FactlinkJailRoot.$factlinkCoreContainer.append(@$el)

    @_attentionSpan = new FactlinkJailRoot.AttentionSpan
      wait_for_neglection: 500
      onAttentionGained: => @$el.addClass 'factlink-control-visible'
      onAttentionLost: => @$el.removeClass 'factlink-control-visible'

    @_robustFrameHover = new FactlinkJailRoot.RobustHover
      $el: @$el
      mouseenter: => @_attentionSpan.gainAttention()
      mouseleave: => @_attentionSpan.loseAttention()
    @$el.on 'click', @_onClick

    FactlinkJailRoot.on 'updateIconButtons', @_update
    @_updatePosition()

    if FactlinkJailRoot.isTouchDevice()
      @$el.addClass 'factlink-control-visible'
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

    FactlinkJailRoot.setElementPosition
      $el: @$el
      top: contentBox.top
      left: contentBox.left + contentBox.width

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
