highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_show_button_open = 350
delay_before_mouseover_detected = 50
delay_before_mouseout_detected = 300

class Highlighter
  constructor: (@$elements, @class) ->
    throw 'Higlighter requires class' unless @class

  highlight:   -> @$elements.addClass(@class)
  dehighlight: -> @$elements.removeClass(@class)

class FactInteraction
  constructor: (elements, @id, @options) ->
    @button_attention = new Factlink.AttentionSpan
      lost_attention:   => @show_button.hide()
      gained_attention: => @show_button.show()
      wait_for_attention:  delay_before_mouseover_detected + delay_between_highlight_and_show_button_open
      wait_for_neglection: delay_before_mouseout_detected

    @highlight_attention = new Factlink.AttentionSpan
      lost_attention:   => @highlighter.dehighlight()
      gained_attention: => @highlighter.highlight()
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
    @button_attention.gain_attention()
    @highlight_attention.gain_attention()
    @show_button.startLoading() # must be called after show
    @options.on_click success: =>
      @button_attention.loose_attention()
      @highlight_attention.loose_attention()

  onFocus: ->
    @button_attention.attend()
    @highlight_attention.attend()
  onBlur:  ->
    @button_attention.neglect()
    @highlight_attention.neglect()

  destroy: ->
    @button_attention.loose_attention()
    @highlight_attention.loose_attention()
    @show_button.destroy()

class FactPromotion
  constructor: (elements) ->
    @highlighter = new Highlighter $(elements), 'fl-highlight'

    @highlight_temporary highlight_time_on_load

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
