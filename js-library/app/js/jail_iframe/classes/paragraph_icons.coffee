class FactlinkJailRoot.ParagraphIcons

  _paragraphHasContent: (el) ->
    $clonedEl = $(el).clone()
    $clonedEl.find('a').remove() # Strip links

    textLength = $clonedEl.text().length
    $clonedEl.remove()

    textLength >= 50

  _addParagraphIcon: (el) ->
    return unless @_paragraphHasContent(el)

    # TODO: actually show icon

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      contentBox = FactlinkJailRoot.contentBox(el)

      FactlinkJailRoot.drawBoundingBox contentBox, 'green'

  addParagraphIcons: ->
    return unless FactlinkJailRoot.can_haz.paragraph_icons

    for el in $('p, h2, h3, h4, h5, h6')
      @_addParagraphIcon el
