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

  addParagraphButtons: ->
    return unless FactlinkJailRoot.can_haz.paragraph_icons

    for paragraphButton in @_paragraphButtons
      paragraphButton.destroy()

    @_addParagraphButtonsBatch $('p, h2, h3, h4, h5, h6, li')

FactlinkJailRoot.core_loaded_promise.then ->
  paragraphButtons = new ParagraphButtons
  paragraphButtons.addParagraphButtons()
