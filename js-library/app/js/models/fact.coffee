highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500

class Factlink.Fact
  constructor: (id, elems) ->
    @id = id
    @elements = elems

    @highlight highlight_time_on_load

    @balloon = new Factlink.Balloon this

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

    deActivateElements = =>
      $(@elements).removeClass('fl-active')

    if delay > 0
      @highlight_timeout = setTimeout deActivateElements, delay
    else
      deActivateElements()

  focus: (e) =>
    clearTimeout(@balloon_hide_timeout)

    @highlight()

    unless @balloon.isVisible() # this enables the balloon to call this without e
      @balloon.show($(e.target).offset().top, e.pageX)

  blur: =>
    clearTimeout(@balloon_hide_timeout)

    unless @balloon.loading()
      @stopHighlighting()

      @balloon_hide_timeout = setTimeout (=> @balloon.hide()), 300

  click: => @openFactlinkModal()

  openFactlinkModal: =>
    @balloon.startLoading()

    Factlink.showInfo @id, =>
      @balloon.stopLoading()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @balloon.destroy()
