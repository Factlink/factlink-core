class IconButton
  constructor: (options) ->
    @_targetElement = options.targetElement
    @_targetOffset = options.targetOffset
    @$el = $ """
      <factlink-icon-button>
        <factlink-icon-button-bubble>
          #{options.content}
          <factlink-icon-button-bubble-triangle></factlink-icon-button-bubble-triangle>
        </factlink-icon-button-bubble>
      </factlink-icon-button>
    """
    FactlinkJailRoot.$factlinkCoreContainer.append(@$el)

    @_setStyles()

    @_robustHover = new FactlinkJailRoot.RobustHover
      $el: @$el
      mouseenter: options.onmouseenter
      mouseleave: options.onmouseleave
    @$el.on 'click', options.onclick


    @_tether = new Tether(@_tether_options())

  _tether_options: () ->
    element: @$el[0]
    target: @_targetElement
    attachment: 'top left'
    targetAttachment: 'top right'
    classPrefix: 'factlink-tether'
    targetOffset: @_targetOffset || '0 0'

  destroy: ->
    @_tether.destroy()
    @_robustHover.destroy()
    @$el.remove()

  fadeIn: ->
    @$el.addClass 'factlink-control-visible'

  fadeOut: ->
    @$el.removeClass 'factlink-control-visible'

  _setStyles: ->
    style = window.getComputedStyle(@_targetElement)
    targetColor = style.color

    # See https://gamedev.stackexchange.com/questions/38536/given-a-rgb-color-x-how-to-find-the-most-contrasting-color-y/38561#38561
    targetRGB = targetColor.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
    r = targetRGB[1]/255; g = targetRGB[2]/255; b = targetRGB[3]/255;
    targetBrightness = 0.2126*r*r + 0.7152*g*g + 0.0722*b*b

    @$el.css
      'line-height': style.lineHeight
      'font-size': Math.max 15, Math.min 20, parseInt style.fontSize

    @$el.find('factlink-icon-button-bubble').css
      'background-color': targetColor
      'color': if targetBrightness > 0.5 then 'black' else 'white'

    @$el.find('factlink-icon-button-bubble-triangle').css
      'border-top-color': targetColor


class FactlinkJailRoot.HighlightIconButtonContainer
  constructor: (highlightElements, factId) ->
    @$highlightElements = $(highlightElements)

    # Calculate a vertical percentage to position the icon relative
    # to the textContainer
    # TODO: really do grouping, so we don't have to do hacks like this!
    textContainer = @_textContainer(@$highlightElements[0])
    textContainerBoundingRect = textContainer.getBoundingClientRect()
    verticalOffset = @$highlightElements[0].getBoundingClientRect().top - textContainerBoundingRect.top
    verticalOffsetPercentage = verticalOffset*100 / textContainerBoundingRect.height

    @_iconButton = new IconButton
      content: ''
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


textFromElement = (element) ->
  selection = document.getSelection()
  selection.removeAllRanges()

  range = document.createRange()
  range.setStart element, 0
  range.setEndAfter element

  selection.addRange(range)
  text = selection.toString()
  selection.removeAllRanges()

  text.trim()


class FactlinkJailRoot.ParagraphIconButtonContainer
  constructor: (paragraphElement) ->
    @$paragraph = $(paragraphElement)

    @_iconButton = new IconButton
      content: '+'
      targetElement: @$paragraph[0]
      onmouseenter: => @_attentionSpan?.gainAttention()
      onmouseleave: => @_attentionSpan?.loseAttention()
      onclick: @_onClick

    FactlinkJailRoot.on 'factlink.factsLoaded factlinkAdded', @_destroyUnlessValid

    if FactlinkJailRoot.isTouchDevice()
      @_iconButton.fadeIn()
    else
      @_attentionSpan = new FactlinkJailRoot.AttentionSpan
        wait_for_neglection: 500
        onAttentionGained: => @_iconButton.fadeIn()
        onAttentionLost: => @_iconButton.fadeOut()

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
    @_attentionSpan?.destroy()
    @_robustParagraphHover?.destroy()
    FactlinkJailRoot.off 'factlink.factsLoaded factlinkAdded', @_destroyUnlessValid
    FactlinkJailRoot.off 'hideAllParagraphButtons', @_onHideAllParagraphButtons

  _destroyUnlessValid: =>
    @destroy() if @_containsFactlink()

  _containsFactlink: ->
    @$paragraph.find('.factlink').length > 0

  _onClick: =>
    text = textFromElement @$paragraph[0]
    siteTitle = document.title
    siteUrl = FactlinkJailRoot.siteUrl()

    FactlinkJailRoot.openModalOverlay()
    FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink',
      text, siteUrl, siteTitle, null
