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


FactlinkJailRoot.isFastScrolling = false
check_scrolling_speed = (is_fast) ->
  return if FactlinkJailRoot.isFastScrolling == is_fast
  FactlinkJailRoot.isFastScrolling = is_fast
  FactlinkJailRoot.trigger 'fast_scrolling_changed'

scroll_speed = new FactlinkJailRoot.Speedmeter
  is_fast_treshold: 1
  get_measure: getScrollTop
  on_change: check_scrolling_speed

FactlinkJailRoot.startFastScrollDetection = ->
  $(window).on 'scroll', scroll_speed.on_possible_speed_change