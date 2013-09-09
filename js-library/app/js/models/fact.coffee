highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500

class Factlink.Fact
  constructor: (id, elems) ->
    @id = id
    @elements = elems

    @highlight highlight_time_on_load

    $(@elements)
      .on('mouseenter', (e)=> @focus(e))
      .on('mouseleave', => @blur())
      .on('click', => @click())
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

  highlight: (duration) ->
    clearTimeout @highlight_timeout

    $(@elements).addClass('fl-active')

    @stopHighlighting(duration) if duration

  stopHighlighting: (delay=0) ->
    clearTimeout(@highlight_timeout)

    actuallyStopHighlighting = => $(@elements).removeClass('fl-active')

    if delay > 0
      @highlight_timeout = setTimeout actuallyStopHighlighting, delay
    else
      actuallyStopHighlighting()

  focus: (e) =>
    clearTimeout(@balloon_hide_timeout)

    @highlight()

    unless @balloon # this enables the balloon to call this without e
      @balloon = new Factlink.Balloon this
      @balloon.show($(e.target).offset().top, e.pageX)

  blur: =>
    clearTimeout(@balloon_hide_timeout)

    unless @balloon?.loading()
      @stopHighlighting()

      @balloon_hide_timeout = setTimeout (=> @balloon?.hide()), 300

  click: => @openFactlinkModal()

  openFactlinkModal: =>
    @balloon?.startLoading()

    Factlink.showInfo @id, =>
      @balloon.hide =>
        @balloon.destroy()
        @balloon = null

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @balloon.destroy()
