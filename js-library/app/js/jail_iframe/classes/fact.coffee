highlight_time_on_load_and_creation = 2000
highlight_time_on_in_view = 1500

delay_before_mouseover_detected = 75

delay_before_mouseout_detected = 300

class Highlighter
  constructor: (@$elements, @class) ->
    throw 'Higlighter requires class' unless @class

  highlight:   -> @$elements.addClass(@class)
  dehighlight: -> @$elements.removeClass(@class)

class FactInteraction
  constructor: (elements, @id, @options) ->
    @highlighter = new Highlighter $(elements), 'fl-active'
    $(elements).on 'click', => @onClick()

    @show_button = new FactlinkJailRoot.ShowButton
      mouseenter: => @highlighter.highlight()
      mouseleave: => @highlighter.dehighlight()
      click:      => @onClick()
    @show_button.placeNearElement elements[0]

  onClick: (options={}) =>
    @show_button.startLoading() # must be called after show
    FactlinkJailRoot.on 'modalOpened', @_onModalOpened, @
    FactlinkJailRoot.openFactlinkModal @id

  _onModalOpened: ->
    @show_button.stopLoading()
    FactlinkJailRoot.off 'modalOpened', @_onModalOpened, @

  destroy: ->
    @show_button.destroy()

class FactLoadPromotion
  constructor: (elements) ->
    @highlighter = new Highlighter $(elements), 'fl-load-highlight'
    @highlighter.highlight()
    setTimeout =>
      @highlighter.dehighlight()
    , highlight_time_on_load_and_creation

class FactScrollPromotion
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


class FactlinkJailRoot.Fact
  constructor: (@id, @elements) ->
    @fact_interaction = new FactInteraction @elements, @id
    @fact_promotion = new FactScrollPromotion(this)
    @fact_load_promotion = new FactLoadPromotion(@elements)

  isInView: ->
    for element in $(@elements)
      return false unless $(element).data('inview') == 'both'
    true

  destroy: ->
    for el in @elements
      $el = $(el)
      $el.remove()

    @fact_interaction.destroy()
