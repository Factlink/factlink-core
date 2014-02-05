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

    # TODO: really do grouping, so we don't have to do hacks like this!
    textContainer = @_textContainer(@$highlightElements[0])
    verticalOffset = @$highlightElements.offset().top - $(textContainer).offset().top
    verticalOffsetPercentage = verticalOffset*100 / $(textContainer).height()

    @_tether = new Tether
      element: @$el[0]
      target: textContainer
      attachment: 'top left'
      targetAttachment: 'top right'
      classPrefix: 'factlink-tether'
      targetOffset: "#{verticalOffsetPercentage}% 0"

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

    @_tether = new Tether
      element: @$el[0]
      target: @$paragraph[0]
      attachment: 'top left'
      targetAttachment: 'top right'
      classPrefix: 'factlink-tether'

    FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', @_destroyUnlessValid

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
    @_tether.destroy()
    @_robustFrameHover.destroy()
    @_attentionSpan.destroy()
    @_robustParagraphHover?.destroy()
    @$el.remove()
    FactlinkJailRoot.off 'factlink.factsLoaded factlinkAdded', @_destroyUnlessValid
    @$paragraph.off 'mousemove', @_showOnlyThisParagraphButton
    FactlinkJailRoot.off 'hideAllParagraphButtons', @_onHideAllParagraphButtons

  _destroyUnlessValid: =>
    @destroy() unless @_valid()

  _valid: ->
    @$paragraph.find('.factlink').length <= 0

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
