#= require jquery.mousewheel

canScroll = ($el, event, delta) ->
  # Scrolling upward but cannot scroll any further
  return false if delta > 0 && $el.scrollTop() <= 0

  # Scrolling downward but cannot scroll any further
  return false if delta < 0 && $el.scrollTop() >= $el[0].scrollHeight - $el.innerHeight()

  true

$.fn.preventScrollPropagation = ->
  @each ->
    $(this).bind 'mousewheel', (event, delta) ->
      event.stopPropagation() # allow nesting of scrollable containers

      event.preventDefault() unless canScroll($(this), event, delta)
