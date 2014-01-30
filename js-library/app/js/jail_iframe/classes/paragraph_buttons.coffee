class ParagraphButtons

  constructor: ->
    @_paragraphButtons = []

  _paragraphHasContent: (el) ->
    $clonedEl = $(el).clone()
    $clonedEl.find('a').remove() # Strip links

    textLength = $clonedEl.text().trim().replace(/\s\s+/g, ' ').length
    $clonedEl.remove()

    textLength >= 50

  _addParagraphButton: (el) ->
    return unless @_paragraphHasContent(el)

    @_paragraphButtons.push new FactlinkJailRoot.ParagraphButton el

  _addParagraphButtonsBatch: (elements) ->
    for el in elements[0...10]
      @_addParagraphButton el

    elementsLeft = elements[10..]
    if elementsLeft.length > 0
      setTimeout (=> @_addParagraphButtonsBatch(elementsLeft)), 200

  _defaultSelector: ->
    "p, h2, h3, h4, h5, h6, li, dd, dt"

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
        return "#{s} p, #{s} h2, #{s} h3, #{s} h4, #{s} h5, #{s} h6, #{s} li, #{s} dd, #{s} dt"

    null

  _paragraphElements: ->
    selector = @_articleContainerSelector() || @_defaultSelector()
    console.info 'FactlinkJailRoot: Paragraph selector:', selector

    $(selector).filter(':visible')

  addParagraphButtons: ->
    for paragraphButton in @_paragraphButtons
      paragraphButton.destroy()

    @_addParagraphButtonsBatch @_paragraphElements()
    FactlinkJailRoot.perf.add_timing_event 'paragraph buttons added'

FactlinkJailRoot.host_ready_promise
  .then(-> FactlinkJailRoot.core_loaded_promise) #wait due to FactlinkJailRoot.can_haz.paragraph_icons
  .then ->
    if  FactlinkJailRoot.can_haz.paragraph_icons
      paragraphButtons = new ParagraphButtons
      paragraphButtons.addParagraphButtons()
