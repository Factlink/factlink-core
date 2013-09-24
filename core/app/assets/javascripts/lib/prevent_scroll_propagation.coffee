#= require jquery.mousewheel

useNativeBehaviour = ($el) ->
  # We explicitly only want a scrollbar when there is something to scroll (overflow-y: auto),
  # but there isn't anything to scroll
  $el.css('overflow-y') == 'auto' && $el[0].scrollHeight <= $el.innerHeight()

preventScroll = ($el, delta) ->
  # Scrolling upward but cannot scroll any further
  return true if delta > 0 && $el.scrollTop() <= 0

  # Scrolling downward but cannot scroll any further
  return true if delta < 0 && $el.scrollTop() >= $el[0].scrollHeight - $el.innerHeight()

  false

$.fn.preventScrollPropagation = ->
  @each ->
    $(this).on 'mousewheel', (event, delta) ->
      $el = $(event.delegateTarget)
      return if useNativeBehaviour($el)

      event.stopPropagation() # allow nesting of scrollable containers
      event.preventDefault() if preventScroll($el, delta)
