highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_show_button_open = 400


class ShowButtonManager
  constructor: (fact, dom_events) ->
    @dom_events = dom_events
    @fact = fact
    @show_button = new Factlink.ShowButton @dom_events

  set_coordinates: (@top, @left) =>

  openShowButton:  =>
    return if @opening_timeout
    @opening_timeout = setTimeout =>
      @_stopOpening()
      @_realOpenShowButton(@top, @left)
    , delay_between_highlight_and_show_button_open

  _realOpenShowButton: (top, left) =>
    @show_button.show(top, left)

  closeShowButton: ->
    @_stopOpening()
    @show_button?.hide()

  startLoading: -> @show_button?.startLoading()

  _stopOpening: ->
    clearTimeout @opening_timeout
    @opening_timeout = null

  destroy: -> @show_button.destroy()

class Highlighter
  constructor: (@$elements) ->

  highlight:   -> @$elements.addClass('fl-active')
  dehighlight: -> @$elements.removeClass('fl-active')

class AttentionSpan
  constructor: (@options={})->
    @_has_attention = false
  attend: ->
    clearTimeout @losing_attention_timeout
    console.info 'attending'
    @gained_attention()
  neglect: ->
    console.info 'neglecting'
    @losing_attention_timeout = setTimeout =>
      @lost_attention()
    , 300

  has_attention: -> @_has_attention

  lost_attention: ->
    console.info 'lost attention'
    @_has_attention = false
    @options.lost_attention?()

  gained_attention: ->
    console.info 'gained attention'
    @_has_attention = true
    @options.gained_attention?()

class Factlink.Fact
  constructor: (@id, @elements) ->
    @attention_span = new AttentionSpan
      lost_attention: => @stopEmphasis()
      gained_attention: => @startEmphasis()

    @highlighter = new Highlighter $(@elements)


    @show_button_manager = new ShowButtonManager this,
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
      @show_button_manager.set_coordinates($(e.target).offset().top, e.pageX)
    @attention_span.attend()

  startEmphasis: ->
    @highlighter.highlight()
    @show_button_manager.openShowButton()

  stopEmphasis: =>
    return if @shouldHaveEmphasis()

    @highlighter.dehighlight()
    @show_button_manager.closeShowButton()

  shouldHaveEmphasis: =>
    @attention_span.has_attention() || @_loading

  openFactlinkModal: =>
    @startLoading()
    Factlink.showInfo @id, => @stopLoading()

  startLoading: ->
    @_loading = true
    @show_button_manager.startLoading()

  stopLoading: ->
    @_loading = false
    @stopEmphasis()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @show_button_manager.closeShowButton()
