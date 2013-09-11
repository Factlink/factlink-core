highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_show_button_open = 400

class Highlighter
  constructor: (@$elements) ->

  highlight:   -> @$elements.addClass('fl-active')
  dehighlight: -> @$elements.removeClass('fl-active')

class Factlink.Fact
  constructor: (@id, @elements) ->
    @attention_span = new Factlink.AttentionSpan
      lost_attention: => @stopEmphasis()
      gained_attention: => @startEmphasis()

    @highlighter = new Highlighter $(@elements)

    @show_button = new Factlink.ShowButton
      mouseenter: => @onFocus()
      mouseleave: => @onBlur()
      click:      => @openFactlinkModal()

    @highlight_temporary highlight_time_on_load

    $(@elements)
      .on('mouseenter', (e)=> @onFocus(e))
      .on('mouseleave', => @onBlur())
      .on('click', => @openFactlinkModal())
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight_temporary(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  highlight_temporary: (duration) ->
    @highlighter.highlight()
    setTimeout (=> @stopEmphasis()), duration

  onBlur: -> @attention_span.neglect()
  onFocus: (e) =>
    if e?
      @show_button.setCoordinates($(e.target).offset().top, e.pageX)
    @attention_span.attend()

  startEmphasis: ->
    @highlighter.highlight()
    @show_button.show()

  stopEmphasis: =>
    return if @shouldHaveEmphasis()

    @highlighter.dehighlight()
    @show_button.hide()

  shouldHaveEmphasis: =>
    @attention_span.has_attention() || @_loading

  openFactlinkModal: =>
    @startLoading()
    Factlink.showInfo @id, => @stopLoading()

  startLoading: ->
    @_loading = true
    @show_button.startLoading()

  stopLoading: ->
    @_loading = false
    @stopEmphasis()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @show_button.destroy()
