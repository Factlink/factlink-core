highlight_time_on_load    = 1500
highlight_time_on_in_view = 1500

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

    @highlight highlight_time_on_load

    @balloon = new Factlink.Balloon id, @

    # Bind the own events
    $(@elements)
      .on('mouseenter', @focus)
      .on('mouseleave', @blur)
      .on('click', @click)
      .on 'inview', (event, isInView, visiblePart) =>
        @highlight(highlight_time_on_in_view) if ( isInView && visiblePart == 'both' )

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

  highlight: (duration) ->
    clearTimeout @highlight_timeout

    $( @elements ).addClass('fl-active')

    @stopHighlighting(duration) if duration

  stopHighlighting: (delay) ->
    clearTimeout(@highlight_timeout)

    deActivateElements = =>
      $(@elements).removeClass('fl-active')

    if delay
      @highlight_timeout = setTimeout deActivateElements, delay
    else
      deActivateElements()

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
