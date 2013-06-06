class Factlink.Fact
  # If you want to support more events add them to this variable:
  _events = ["focus", "blur", "click", "update"]

  constructor: (id, elems, opinions) ->
    # Internal object which will hold all bound event handlers
    @_bound_events = {}

    @elements = elems

    @obj =
      id: id
      opinions: opinions

    @createEventHandlers(_events)

    @highlight(1500)

    @balloon = new Factlink.Balloon id, @

    # Bind the own events
    $(@elements)
      .on('mouseenter', @focus)
      .on('mouseleave', @blur)
      .on('click', @click)
      .on 'inview', (event, isInView) =>
        @highlight(1500) if ( isInView )

    @bindFocus()

    @bindClick id

  # This may look like some magic, but here we expose the Fact.blur/focus/click
  # methods
  createEventHandlers: (events) ->
    @createEventHandler event_handle for event_handle in events

  createEventHandler: (event_handle) =>
    @_bound_events[event_handle] = []

    @[event_handle] = (() =>
      e = event_handle

      (supplied_args...) =>
        args = [e].concat supplied_args

        if $.isFunction args[1]
          @bind.apply this, args
        else
          @trigger.apply this, args
    )()

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
      @highlight_timeout = setTimeout( =>
        $( @elements ).removeClass('fl-active')
      , timer)
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

        @timeout = setTimeout =>
          @balloon.hide()
        , 300

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
