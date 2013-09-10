highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_balloon_open = 400


class BalloonManager
  constructor: (fact, dom_events) ->
    @dom_events = dom_events
    @fact = fact

  set_coordinates: (@top, @left) =>

  openBalloon:  =>
    return if @opening_timeout
    @opening_timeout = setTimeout =>
      @_stopOpening()
      @_realOpenBalloon(@top, @left)
    , delay_between_highlight_and_balloon_open

  _realOpenBalloon: (top, left) =>
    return if @balloon
    @balloon = new Factlink.Balloon @dom_events
    @balloon.show(top, left)

  closeBalloon: ->
    @_stopOpening()
    @balloon?.hide (balloon)-> balloon.destroy()
    @balloon = null

  startLoading: -> @balloon?.startLoading()

  _stopOpening: ->
    clearTimeout @opening_timeout
    @opening_timeout = null

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


    @balloon_manager = new BalloonManager this,
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
      @balloon_manager.set_coordinates($(e.target).offset().top, e.pageX)
    @attention_span.attend()

  startEmphasis: ->
    @highlighter.highlight()
    @balloon_manager.openBalloon()

  stopEmphasis: =>
    return if @shouldHaveEmphasis()

    @highlighter.dehighlight()
    @balloon_manager.closeBalloon()

  shouldHaveEmphasis: =>
    @attention_span.has_attention() || @_loading

  openFactlinkModal: =>
    @startLoading()
    Factlink.showInfo @id, => @stopLoading()

  startLoading: ->
    @_loading = true
    @balloon_manager.startLoading()

  stopLoading: ->
    @_loading = false
    @stopEmphasis()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @balloon_manager.closeBalloon()
