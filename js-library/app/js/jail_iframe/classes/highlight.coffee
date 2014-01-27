highlight_time_on_load_and_creation = 2000
highlight_time_on_in_view = 1500

class Highlighter
  constructor: (@$elements, @className) ->
    throw 'Higlighter requires class' unless @className

  highlight:   -> @$elements.addClass(@className)
  dehighlight: -> @$elements.removeClass(@className)

class HighlightInteraction
  constructor: (elements, @id, @options) ->
    $elements = $(elements)

    @highlighter = new Highlighter $elements, 'fl-active'

    @show_button = new FactlinkJailRoot.ShowButton
      el: elements[0]
      callbacks:
        mouseenter: @_onHover
        mouseleave: @_onUnhover
        click:      @_onClick

    $elements.on 'click', @_onClick
    $elements.on 'mouseenter', @_onHover
    $elements.on 'mouseleave', @_onUnhover

  _onClick: =>
    FactlinkJailRoot.on 'modalOpened', @_onModalOpened, @
    FactlinkJailRoot.openFactlinkModal @id

  _onModalOpened: ->
    FactlinkJailRoot.off 'modalOpened', @_onModalOpened, @

  _onHover: =>
    @show_button.startHovering()
    @highlighter.highlight()

  _onUnhover: =>
    @show_button.stopHovering()
    @highlighter.dehighlight()

  destroy: ->
    @show_button.destroy()

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
    @fact_interaction = new HighlightInteraction @elements, @id
    @fact_promotion = new HighlightScrollPromotion(this)
    @fact_load_promotion = new HighlightLoadPromotion(@elements)

  isInView: ->
    for element in $(@elements)
      return false unless $(element).data('inview') == 'both'
    true

  destroy: ->
    for el in @elements
      $(el).contents().unwrap()

    @fact_interaction.destroy()
