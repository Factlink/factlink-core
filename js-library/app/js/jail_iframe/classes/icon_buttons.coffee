class IconButton
  constructor: (options) ->
    $targetElement = $(options.targetElement)

    @$el = $ """
      <factlink-icon-button>
        <factlink-bubble-icon>
          #{options.content || ''}
          <factlink-bubble-icon-triangle></factlink-bubble-icon-triangle>
        </factlink-bubble-icon>
      </factlink-icon-button>
    """
    FactlinkJailRoot.$factlinkCoreContainer.append(@$el)

    @_tether = new Tether
      element: @$el[0]
      target: $targetElement[0]
      attachment: 'top left'
      targetAttachment: 'top right'
      classPrefix: 'factlink-tether'
      targetOffset: options.targetOffset || '0 0'

    @_robustHover = new FactlinkJailRoot.RobustHover
      $el: @$el
      mouseenter: options.onmouseenter
      mouseleave: options.onmouseleave
    @$el.on 'click', options.onclick

    targetColor = $targetElement.css('color')

    # See https://gamedev.stackexchange.com/questions/38536/given-a-rgb-color-x-how-to-find-the-most-contrasting-color-y/38561#38561
    targetRGB = targetColor.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
    r = targetRGB[1]/255; g = targetRGB[2]/255; b = targetRGB[3]/255;
    targetBrightness = 0.2126*r*r + 0.7152*g*g + 0.0722*b*b

    @$el.css
      'line-height': $targetElement.css('line-height')
      'font-size': Math.max 15, Math.min 20, parseInt $targetElement.css('font-size')
      'color': if targetBrightness > 0.5 then 'black' else 'white'

    @$el.find('factlink-bubble-icon').css
      'background-color': targetColor

    @$el.find('factlink-bubble-icon-triangle').css
      'border-top-color': targetColor

  destroy: ->
    @_tether.destroy()
    @_robustHover.destroy()
    @$el.remove()

  fadeIn: ->
    @$el.addClass 'factlink-control-visible'

  fadeOut: ->
    @$el.removeClass 'factlink-control-visible'

class FactlinkJailRoot.ShowButton
  constructor: (highlightElements, factId) ->
    @$highlightElements = $(highlightElements)

    # TODO: really do grouping, so we don't have to do hacks like this!
    textContainer = @_textContainer(@$highlightElements[0])
    textContainerBoundingRect = textContainer.getBoundingClientRect()
    verticalOffset = @$highlightElements[0].getBoundingClientRect().top - textContainerBoundingRect.top
    verticalOffsetPercentage = verticalOffset*100 / textContainerBoundingRect.height

    @_iconButton = new IconButton
      targetElement: textContainer
      targetOffset: "#{verticalOffsetPercentage}% 0"
      onmouseenter: @_onHover
      onmouseleave: @_onUnhover
      onclick: @_onClick

    @_factId = factId

    @_iconButton.fadeIn()

  destroy: ->
    @_iconButton.destroy()

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

    @_iconButton = new IconButton
      content: '+'
      targetElement: @$paragraph[0]
      onmouseenter: => @_attentionSpan.gainAttention()
      onmouseleave: => @_attentionSpan.loseAttention()
      onclick: @_onClick

    @_attentionSpan = new FactlinkJailRoot.AttentionSpan
      wait_for_neglection: 500
      onAttentionGained: => @_iconButton.fadeIn()
      onAttentionLost: => @_iconButton.fadeOut()

    FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', @_destroyUnlessValid

    if FactlinkJailRoot.isTouchDevice()
      @_iconButton.fadeIn()
    else
      @_robustParagraphHover = new FactlinkJailRoot.RobustHover
        $el: @$paragraph
        mouseenter: @_showOnlyThisParagraphButton
        mouseleave: => @_attentionSpan.loseAttention()
      FactlinkJailRoot.on 'hideAllParagraphButtons', @_onHideAllParagraphButtons

  _showOnlyThisParagraphButton: =>
    FactlinkJailRoot.trigger 'hideAllParagraphButtons'
    @_attentionSpan.gainAttention()

  _onHideAllParagraphButtons: =>
    @_attentionSpan.loseAttentionNow()

  destroy: ->
    @_iconButton.destroy()
    @_attentionSpan.destroy()
    @_robustParagraphHover?.destroy()
    FactlinkJailRoot.off 'factlink.factsLoaded factlinkAdded', @_destroyUnlessValid
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
