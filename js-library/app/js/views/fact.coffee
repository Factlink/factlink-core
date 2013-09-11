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
  constructor: (@fact) ->
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

    @highlighter = new Highlighter $(@fact.elements), 'fl-active'

    @show_button = new Factlink.ShowButton
      mouseenter: => @onFocus()
      mouseleave: => @onBlur()
      click:      => @openFactlinkModal()

    $(@fact.elements)
      .on 'mouseenter', (e) =>
        @onFocus()
        @show_button.setCoordinates($(e.target).offset().top, e.pageX)
      .on 'mouseleave', =>
        @onBlur()
      .on 'click', =>
        @openFactlinkModal()

  attentions_do: (action) ->
    for attention in [@button_attention, @highlight_attention]
      attention[action]()

  openFactlinkModal: ->
    @show_button.startLoading()

    @attentions_do 'gain_attention'
    Factlink.showInfo @fact.id, => @attentions_do 'loose_attention'

  onFocus: -> @attentions_do 'attend'
  onBlur:  -> @attentions_do 'neglect'

  destroy: ->
    @attentions_do 'loose_attention'
    @show_button.destroy()

class Factlink.Fact
  constructor: (@id, @elements) ->
    @fact_interaction = new FactInteraction(this)

    @highlighter = new Highlighter $(elements), 'fl-highlight'

    @highlight_temporary highlight_time_on_load

    $(@elements).on 'inview', (event, isInView, visiblePart) =>
      @highlight_temporary(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )


  highlight_temporary: (duration) ->
    @highlighter.highlight()
    setTimeout (=> @highlighter.dehighlight()), duration

  destroy: ->
    console.info "DESTROY!!! MUHAHAHAHAHA"
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @fact_interaction.destroy()
