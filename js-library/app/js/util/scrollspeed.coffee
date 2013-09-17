getScrollTop = ->
  # copied this logic from inView
  # I assumed this supports some legacy browsers,
  # since this functionality is used in combination with
  # inView I want to support exactly the same browsers
  if window.pageYOffset?
    window.pageYOffset
  else if  document.documentElement.scrollTop?
    document.documentElement.scrollTop
  else
    document.body.scrollTop

scroll_speed = new Factlink.Speedmeter
  speeding: 1
  get_measure: -> getScrollTop()
  on_change: -> check_scrolling_speed()

check_scrolling_speed = =>
  if scroll_speed.is_fast()
    Factlink.el.trigger 'fast_scrolling'
  else
    Factlink.el.trigger 'slow_scrolling'

# flag to ensure we only fire on state change
currently_fast_scrolling = false
Factlink.el.on
  fast_scrolling: =>
    return if currently_fast_scrolling
    currently_fast_scrolling = true
    Factlink.el.addClass 'fl-fast-scrolling'
    Factlink.el.trigger 'started_fast_scrolling'
  slow_scrolling: =>
    return unless currently_fast_scrolling
    currently_fast_scrolling = false
    Factlink.el.removeClass 'fl-fast-scrolling'
    Factlink.el.trigger 'stopped_fast_scrolling'

Factlink.startFastScrollDetection = =>
  $(window).on 'scroll', scroll_speed.start_measuring
