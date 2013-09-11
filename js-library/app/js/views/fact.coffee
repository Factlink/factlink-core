highlight_time_on_load_and_creation    = 1000
highlight_time_on_in_view = 1500

delay_before_mouseover_detected = 75
delay_between_highlight_and_show_button_open = 325

delay_before_mouseout_detected = 300


class Highlighter
  constructor: (@$elements, @class) ->
    throw 'Higlighter requires class' unless @class

  highlight:   -> @$elements.addClass(@class)
  dehighlight: -> @$elements.removeClass(@class)

class FactInteraction
  constructor: (elements, @id, @options) ->
    @button_attention = new Factlink.AttentionSpan
      onAttentionLost:   => @show_button.hide()
      onAttentionGained: => @show_button.show()
      wait_for_attention:  delay_before_mouseover_detected + delay_between_highlight_and_show_button_open
      wait_for_neglection: delay_before_mouseout_detected

    @highlight_attention = new Factlink.AttentionSpan
      onAttentionLost:   => @highlighter.dehighlight()
      onAttentionGained: => @highlighter.highlight()
      wait_for_attention:  delay_before_mouseover_detected
      wait_for_neglection: delay_before_mouseout_detected

    @highlighter = new Highlighter $(elements), 'fl-active'

    @show_button = new Factlink.ShowButton
      mouseenter: => @onFocus()
      mouseleave: => @onBlur()
      click:      => @onClick()

    $(elements).on
      mouseenter: (e) =>
        @onFocus()
        @show_button.setCoordinates($(e.target).offset().top, e.pageX)
      mouseleave: => @onBlur()
      click: => @onClick()

  onClick: (options={}) =>
    @button_attention.gainAttentionNow()
    @highlight_attention.gainAttentionNow()
    @show_button.startLoading() # must be called after show
    @options.on_click success: =>
      @button_attention.loseAttentionNow()
      @highlight_attention.loseAttentionNow()

  onFocus: ->
    @button_attention.gainAttention()
    @highlight_attention.gainAttention()
  onBlur:  ->
    @button_attention.loseAttention()
    @highlight_attention.loseAttention()

  destroy: ->
    @button_attention.loseAttentionNow()
    @highlight_attention.loseAttentionNow()
    @show_button.destroy()

class FactPromotion
  constructor: (elements) ->
    @highlighter = new Highlighter $(elements), 'fl-highlight'

    @highlight_temporary highlight_time_on_load_and_creation

    $(elements).on 'inview', (event, isInView, visiblePart) =>
      @highlight_temporary(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  highlight_temporary: (duration) ->
    @highlighter.highlight()
    setTimeout (=> @highlighter.dehighlight()), duration

class Factlink.Fact
  constructor: (@id, @elements) ->
    @fact_interaction = new FactInteraction @elements, @id,
      on_click: @openFactlinkModal
    @fact_promotion = new FactPromotion(@elements)


  openFactlinkModal: (options={})=>
    Factlink.showInfo @id, => options.success?()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @fact_interaction.destroy()
