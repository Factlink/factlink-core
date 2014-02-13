highlightsByFactIds = {}
highlightedFactId = null

class FactlinkJailRoot.Highlight
  constructor: (@id, @elements) ->
    @show_button = new FactlinkJailRoot.HighlightIconButtonContainer @elements, @id
    highlightsByFactIds[id] ?= []
    highlightsByFactIds[id].push @
    if @id == highlightedFactId
      @highlight()

  highlight:   -> $(@elements).addClass('fl-core-highlight')
  dehighlight: -> $(@elements).removeClass('fl-core-highlight')

FactlinkJailRoot.showCoreHighlight = (factId) ->
  for highlight in highlightsByFactIds[highlightedFactId] || []
    highlight.dehighlight()

  highlightedFactId = factId

  for highlight in highlightsByFactIds[highlightedFactId] || []
    highlight.highlight()
