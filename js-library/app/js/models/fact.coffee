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


class Factlink.Fact
  constructor: (id, elems) ->
    @id = id
    @elements = elems

    @highlighter = new Highlighter $(@elements)

    @highlight_temporary highlight_time_on_load

    @balloon_manager = new BalloonManager this,
      mouseenter: => @onFocus()
      mouseleave: => @onBlur()
      click:      => @openFactlinkModal()

    $(@elements)
      .on('mouseenter', (e)=> @onFocus(e))
      .on('mouseleave', => @onBlur())
      .on('click', => @openFactlinkModal())
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight_temporary(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  highlight_temporary: (duration) ->
    @highlighter.highlight()
    @stopHighlighting(duration)

  onBlur: ->
    @stopHighlighting(300)

  onFocus: (e) =>
    clearTimeout @stop_highlighting_timeout
    @highlighter.highlight()
    if e?
      @balloon_manager.set_coordinates($(e.target).offset().top, e.pageX)
    @balloon_manager.openBalloon()

  stopHighlighting: (delay=0) ->
    return if @_loading # don't hide while loading
    clearTimeout(@stop_highlighting_timeout)

    @stop_highlighting_timeout = setTimeout (=>@actuallyStopHighlighting()), delay

  actuallyStopHighlighting: =>
    @highlighter.dehighlight()
    @balloon_manager.closeBalloon()

  openFactlinkModal: =>
    @startLoading()
    Factlink.showInfo @id, =>
      @stopLoading()

  startLoading: ->
    @_loading = true
    @balloon_manager.startLoading()

  stopLoading: ->
    @_loading = false
    @actuallyStopHighlighting()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @balloon_manager.closeBalloon()
