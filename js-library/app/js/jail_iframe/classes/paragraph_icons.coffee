class ParagraphIcon
  constructor: (@el) ->
    @$el = $(@el)

    # TODO: actually show icon

    if FactlinkJailRoot.can_haz.debug_bounding_boxes
      contentBox = FactlinkJailRoot.contentBox(el)

      @$boundingBox = FactlinkJailRoot.drawBoundingBox contentBox, 'green'

  remove: ->
    @$boundingBox?.remove()


class FactlinkJailRoot.ParagraphIcons

  constructor: ->
    @_paragraphIcons = []

  _paragraphHasContent: (el) ->
    $clonedEl = $(el).clone()
    $clonedEl.find('a').remove() # Strip links

    textLength = $clonedEl.text().length
    $clonedEl.remove()

    textLength >= 50

  _containsFactlink: (el) ->
    $(el).find('.factlink').length > 0

  _addParagraphIcon: (el) ->
    return unless @_paragraphHasContent(el)
    return if @_containsFactlink(el)

    @_paragraphIcons.push new ParagraphIcon el

  addParagraphIcons: ->
    return unless FactlinkJailRoot.can_haz.paragraph_icons

    for paragraphIcon in @_paragraphIcons
      paragraphIcon.remove()

    for el in $('p, h2, h3, h4, h5, h6')
      @_addParagraphIcon el

paragraphIcons = new FactlinkJailRoot.ParagraphIcons

FactlinkJailRoot.on 'factlink.factsLoaded coreLoad', ->
  paragraphIcons.addParagraphIcons()
