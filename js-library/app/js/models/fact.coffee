class Factlink.Fact
  # If you want to support more events add them to this variable:
  _events: ["focus", "blur", "click", "update"]

  constructor: (id, elems) ->
    # Internal object which will hold all bound event handlers
    @_bound_events = {}

    @elements = elems

    @obj =
      id: id

    @createEventHandlers(@_events)

    @highlight(1500)

    @balloon = new Factlink.Balloon this

    # Bind the own events
    $(@elements)
      .on('mouseenter', @focus)
      .on('mouseleave', @blur)
      .on('click', @click)
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight(1500) if ( isInView && visiblePart == 'both' )

    @bindFocus()

    @bindClick id

  # This may look like some magic, but here we expose the Fact.blur/focus/click
  # methods
  createEventHandlers: (events) ->
    @createEventHandler event_handle for event_handle in events

  createEventHandler: (event_handle) ->
    @_bound_events[event_handle] = []

    @[event_handle] = (event, args...) =>
      if $.isFunction event
        @bind event_handle, event
      else
        @trigger event_handle, event, args...

  bind: (type, fn) ->
    @_bound_events[type].push fn

  trigger: (type, args...) ->
    for bound_event in @_bound_events[type]
      bound_event.apply this, args

  highlight: (timer) ->
    clearTimeout @highlight_timeout

    $( @elements ).addClass('fl-active')

    if timer
      @stopHighlighting(timer)

  stopHighlighting: (timer) ->
    clearTimeout(@highlight_timeout)

    if timer
      deActivateElements = =>
        $(@elements).removeClass('fl-active')

      @highlight_timeout = setTimeout deActivateElements, timer
    else
      $( @elements ).removeClass('fl-active')

  bindFocus: ->
    @focus (e) =>
      clearTimeout(@timeout)

      @highlight()

      unless @balloon.isVisible()
        # Need to call a direct .hide() here to make sure not two popups are
        # open at a time
        Factlink.el.find('div.fl-popup').hide()

        @balloon.show($(e.target).offset().top, e.pageX, e.show_fast)

    @blur (e) =>
      clearTimeout(@timeout)

      unless @balloon.loading()
        @stopHighlighting()

        hideBalloon = =>
          @balloon.hide()

        @timeout = setTimeout hideBalloon, 300

  bindClick: (id) ->
    @click =>
      @balloon.startLoading()

      Factlink.showInfo id, =>
        @balloon.stopLoading()

  destroy: ->
    for el in @elements
      $el = $(el)
      unless $el.is('.fl-first')
        $el.before $el.html()

      $el.remove()

    @balloon.destroy()
