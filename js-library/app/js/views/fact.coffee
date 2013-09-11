highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_show_button_open = 350
delay_before_mouseover_detected = 50
delay_before_mouseout_detected = 300

class Highlighter
  constructor: (@$elements) ->

  highlight:   -> @$elements.addClass('fl-active')
  dehighlight: -> @$elements.removeClass('fl-active')

class Factlink.Fact
  constructor: (@id, @elements) ->
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

    @highlighter = new Highlighter $(@elements)

    @show_button = new Factlink.ShowButton
      mouseenter: => @onFocus()
      mouseleave: => @onBlur()
      click:      => @openFactlinkModal()

    @highlight_temporary highlight_time_on_load

    $(@elements)
      .on('mouseenter', (e) =>
        @onFocus()
        @show_button.setCoordinates($(e.target).offset().top, e.pageX)
      .on('mouseleave', => @onBlur())
      .on('click', => @openFactlinkModal())
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight_temporary(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  attentions_do: (action) ->
    for attention in [@button_attention, @highlight_attention]
      attention[action]()

  highlight_temporary: (duration) ->
    @highlighter.highlight()
    setTimeout (=> highlight_attention.check_attention()), duration

  onFocus: -> @attentions_do 'attend'
  onBlur:  -> @attentions_do 'neglect'

  openFactlinkModal: ->
    @show_button.startLoading()

    @attentions_do 'gain_attention'
    Factlink.showInfo @id, => @attentions_do 'loose_attention'

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @show_button.destroy()
