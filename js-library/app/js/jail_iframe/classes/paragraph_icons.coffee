class FactlinkJailRoot.ParagraphIcons

  _paragraphHasContent: (el) ->
    $clonedEl = $(el).clone()
    $clonedEl.find('a').remove() # Strip links

    textLength = $clonedEl.text().length
    $clonedEl.remove()

    textLength >= 50

  $paragraphs: ->
    paragraphSelector = 'p, h2, h3, h4, h5, h6'

    $(el for el in $(paragraphSelector) when @_paragraphHasContent(el))

  highlightParagraphs: ->
    @$paragraphs().css 'outline', '3px solid red'

FactlinkJailRoot.paragraphIcons = new FactlinkJailRoot.ParagraphIcons

if FactlinkJailRoot.can_haz.paragraph_icons
  FactlinkJailRoot.paragraphIcons.highlightParagraphs()
