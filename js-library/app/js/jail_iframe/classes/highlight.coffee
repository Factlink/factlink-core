highlightsByFactIds = {}
highlightedFactId = null

class FactlinkJailRoot.Highlight
  constructor: (@id, @elements) ->
    @show_button = new FactlinkJailRoot.ShowButton @elements, @id
    highlightsByFactIds[id] ?= []
    highlightsByFactIds[id].push @
    if @id == highlightedFactId
      @highlight()

  highlight:   -> $(@elements).addClass('fl-core-highlight')
  dehighlight: -> $(@elements).removeClass('fl-core-highlight')

  destroy: ->
    $(@elements).contents().unwrap()
    @show_button.destroy()

FactlinkJailRoot.showCoreHighlight = (factId) ->
  for highlight in highlightsByFactIds[highlightedFactId] || []
    highlight.dehighlight()

  highlightedFactId = factId

  for highlight in highlightsByFactIds[highlightedFactId] || []
    highlight.highlight()


FactlinkJailRoot.destroyCoreHighlight = (factId) ->
  for fact in highlightsByFactIds[factId] || []
    fact.destroy()
  delete highlightsByFactIds[factId]

