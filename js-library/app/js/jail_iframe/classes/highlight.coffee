highlight_time_on_in_view = 1500

class Highlighter
  constructor: (@$elements, @className) ->
    throw 'Higlighter requires class' unless @className

  highlight:   -> @$elements.addClass(@className)
  dehighlight: -> @$elements.removeClass(@className)


class FactlinkJailRoot.Highlight
  constructor: (@id, @elements) ->
    @show_button = new FactlinkJailRoot.ShowButton @elements, @id
    @core_highlighter = new Highlighter $(@elements), 'fl-core-highlight'

  destroy: ->
    for el in @elements
      $(el).contents().unwrap()

    @show_button.destroy()

previousCoreHighlightId = null
FactlinkJailRoot.showCoreHighlight = (factId) ->
  for highlight in FactlinkJailRoot.highlightsByFactIds[previousCoreHighlightId] || []
    highlight.core_highlighter.dehighlight()

  for highlight in FactlinkJailRoot.highlightsByFactIds[factId] || []
    highlight.core_highlighter.highlight()

  previousCoreHighlightId = factId
