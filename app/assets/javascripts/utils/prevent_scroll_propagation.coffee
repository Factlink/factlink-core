#= require jquery.mousewheel

shouldUseNativeBehaviour = ($el) ->
  # We explicitly only want a scrollbar when there is something to scroll (overflow-y: auto),
  # but there isn't anything to scroll
  $el.css('overflow-y') == 'auto' && $el[0].scrollHeight <= $el.innerHeight()

shouldPreventScroll = ($el, deltaY) ->
  # Scrolling upward but cannot scroll any further
  return true if deltaY > 0 && $el.scrollTop() <= 0

  # Scrolling downward but cannot scroll any further
  return true if deltaY < 0 && $el.scrollTop() >= $el[0].scrollHeight - $el.innerHeight()

  false

$.fn.preventScrollPropagation = ->
  @each ->
    $(this).on 'mousewheel', (event, delta, deltaX, deltaY) ->
      $el = $(event.delegateTarget)
      return if shouldUseNativeBehaviour($el)

      # Allow nesting of scrollable containers
      # This does mean that all children should also have preventScrollPropagation!
      event.stopPropagation()

      if shouldPreventScroll($el, deltaY)
        event.preventDefault()
