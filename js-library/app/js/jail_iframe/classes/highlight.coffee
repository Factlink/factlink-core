highlight_time_on_load_and_creation = 2000
highlight_time_on_in_view = 1500

class Highlighter
  constructor: (@$elements, @className) ->
    throw 'Higlighter requires class' unless @className

  highlight:   -> @$elements.addClass(@className)
  dehighlight: -> @$elements.removeClass(@className)

class HighlightLoadPromotion
  constructor: (elements) ->
    @highlighter = new Highlighter $(elements), 'fl-load-highlight'
    @highlighter.highlight()
    setTimeout =>
      @highlighter.dehighlight()
    , highlight_time_on_load_and_creation

class HighlightScrollPromotion
  # states: invisible, just_visible, visible

  constructor: (@fact) ->
    @highlighter = new Highlighter $(fact.elements), 'fl-scroll-highlight'
    $(fact.elements).inview(@onSomethingChanged)
    FactlinkJailRoot.on 'fast_scrolling_changed', @onSomethingChanged
    @state = 'visible'

  onSomethingChanged: =>
    switch @state
      when 'invisible'
        if @fact.isInView() && ! FactlinkJailRoot.isFastScrolling
          @switchToState 'just_visible'
          @timeout_handler = setTimeout =>
            @switchToState 'visible'
          , highlight_time_on_in_view
      when 'visible', 'just_visible'
        if !@fact.isInView()
          clearTimeout @timeout_handler
          @switchToState 'invisible'

  switchToState: (to_state) =>
    return if to_state == @state

    if to_state == 'just_visible'
      @highlighter.highlight()
    else
      @highlighter.dehighlight()
    @state = to_state

class FactlinkJailRoot.Highlight
  constructor: (@id, @elements) ->
    @show_button = new FactlinkJailRoot.ShowButton @elements, @id
    @fact_promotion = new HighlightScrollPromotion(this)
    @fact_load_promotion = new HighlightLoadPromotion(@elements)
    @core_highlighter = new Highlighter $(@elements), 'fl-core-highlight'

  isInView: ->
    for element in $(@elements)
      return false unless $(element).data('inview') == 'both'
    true

  destroy: ->
    for el in @elements
      $(el).contents().unwrap()

    @show_button.destroy()

FactlinkJailRoot.highlightedFactId = null
FactlinkJailRoot.showCoreHighlight = (factId) ->
  for highlight in FactlinkJailRoot.highlightsByFactIds[FactlinkJailRoot.highlightedFactId] || []
    highlight.core_highlighter.dehighlight()

  for highlight in FactlinkJailRoot.highlightsByFactIds[factId] || []
    highlight.core_highlighter.highlight()

  FactlinkJailRoot.highlightedFactId = factId
