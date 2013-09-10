highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500
delay_between_highlight_and_balloon_open = 400


class BalloonManager
  constructor: (fact, dom_events) ->
    @dom_events = dom_events
    @fact = fact

  openBalloon: (top, left) =>
    return if @opening_timeout
    @opening_timeout = setTimeout =>
      @_stopOpening()
      @_realOpenBalloon(top, left)
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


class Factlink.Fact
  constructor: (id, elems) ->
    @id = id
    @elements = elems

    @highlight highlight_time_on_load

    @balloon_manager = new BalloonManager this,
      mouseenter: => @highlight()
      mouseleave: => @considerStoppingWithHighlighting()
      click:      => @openFactlinkModal()

    $(@elements)
      .on('mouseenter', (e)=> @highlightAndOpenBalloon(e))
      .on('mouseleave', => @considerStoppingWithHighlighting())
      .on('click', => @openFactlinkModal())
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  highlight: (duration) ->
    clearTimeout @stop_highlighting_timeout

    $(@elements).addClass('fl-active')

    @stopHighlighting(duration) if duration

  considerStoppingWithHighlighting: -> @stopHighlighting(300)

  stopHighlighting: (delay=0) ->
    return if @_loading # don't hide while loading
    clearTimeout(@stop_highlighting_timeout)

    actuallyStopHighlighting = =>
      $(@elements).removeClass('fl-active')
      @balloon_manager.closeBalloon()

    @stop_highlighting_timeout = setTimeout actuallyStopHighlighting, delay

  highlightAndOpenBalloon: (e) =>
    @highlight()
    @balloon_manager.openBalloon($(e.target).offset().top, e.pageX)

  openFactlinkModal: =>
    @startLoading()
    Factlink.showInfo @id, =>
      @stopLoading()

  startLoading: ->
    @_loading = true
    @balloon_manager.startLoading()

  stopLoading: ->
      @_loading = false
      @stopHighlighting()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @balloon_manager.closeBalloon()
