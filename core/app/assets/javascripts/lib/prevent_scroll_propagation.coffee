#= require jquery.mousewheel

shouldHandleScrolling = (event) ->
  $el = $(event.delegateTarget)

  # There isn't anything to scroll, and we only show a scrollbar when there is
  return false if $el[0].scrollHeight <= $el.innerHeight() && $el.css('overflow-y') == 'auto'

  true

preventScroll = (event, delta) ->
  $el = $(event.delegateTarget)

  # Scrolling upward but cannot scroll any further
  return true if delta > 0 && $el.scrollTop() <= 0

  # Scrolling downward but cannot scroll any further
  return true if delta < 0 && $el.scrollTop() >= $el[0].scrollHeight - $el.innerHeight()

  false

$.fn.preventScrollPropagation = ->
  @each ->
    $(this).on 'mousewheel', (event, delta) ->
      return unless shouldHandleScrolling(event)

      event.stopPropagation() # allow nesting of scrollable containers
      event.preventDefault() if preventScroll(event, delta)
