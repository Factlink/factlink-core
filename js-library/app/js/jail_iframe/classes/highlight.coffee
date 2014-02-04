class FactlinkJailRoot.Highlight
  constructor: (@id, @elements) ->
    @show_button = new FactlinkJailRoot.ShowButton @elements, @id

  highlight:   -> @$elements.addClass('fl-core-highlight')
  dehighlight: -> @$elements.removeClass('fl-core-highlight')

  destroy: ->
    for el in @elements
      $(el).contents().unwrap()

    @show_button.destroy()

previousCoreHighlightId = null
FactlinkJailRoot.showCoreHighlight = (factId) ->
  for highlight in FactlinkJailRoot.highlightsByFactIds[previousCoreHighlightId] || []
    highlight.dehighlight()

  for highlight in FactlinkJailRoot.highlightsByFactIds[factId] || []
    highlight.highlight()

  previousCoreHighlightId = factId
