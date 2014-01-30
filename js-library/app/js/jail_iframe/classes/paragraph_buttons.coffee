class ParagraphButtons

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

    @_paragraphButtons.push new FactlinkJailRoot.ParagraphButton el

  _addParagraphButtonsBatch: (elements) ->
    for el in elements[0...10]
      @_addParagraphButton el

    elementsLeft = elements[10..]
    setTimeout (=> @_addParagraphButtonsBatch(elementsLeft)), 200

  _paragraphSelectors: ->
    ['p', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'dd', 'dt',
     '.paragraph', '.para', '.par']

  _prefixedParagraphSelectors: (prefix) ->
    (prefix + ' ' + selector for selector in @_paragraphSelectors())

  _defaultSelector: ->
    @_paragraphSelectors().join(',')

  _articleContainerSelector: ->
    selectors = [
      'article', 'div.article', 'div.story', 'div.single-post', 'div.post'
      'div#bodyContent', 'div#content', 'div.content', 'div#main', 'div.main'
      'div#page', 'div.page', 'div#site', 'div.site'
    ]

    for s in selectors
      $element = $(s)
      # Only match if selector is unique
      if $element.length == 1 && $element.is(':visible')
        return @_prefixedParagraphSelectors(s).join(',')

    null

  _paragraphElements: ->
    selector = @_articleContainerSelector() || @_defaultSelector()
    console.info 'FactlinkJailRoot: Paragraph selector:', selector

    $(selector).distinctDescendants().filter(':visible')

  addParagraphButtons: ->
    return unless FactlinkJailRoot.can_haz.paragraph_icons

    for paragraphButton in @_paragraphButtons
      paragraphButton.destroy()

    @_addParagraphButtonsBatch @_paragraphElements()
    FactlinkJailRoot.perf.add_timing_event 'paragraph buttons added'

FactlinkJailRoot.core_loaded_promise.then ->
  paragraphButtons = new ParagraphButtons
  paragraphButtons.addParagraphButtons()
