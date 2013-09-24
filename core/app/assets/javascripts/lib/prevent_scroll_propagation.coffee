#= require jquery.mousewheel

$.fn.preventScrollPropagation = ->
  @each ->
    $(this).bind 'mousewheel', (event, delta) ->
      event.stopPropagation() # allow nesting of scrollable containers

      if delta > 0 && $(this).scrollTop() <= 0
        event.preventDefault()
      else if delta < 0 && $(this).scrollTop() >= $(this).get(0).scrollHeight - $(this).innerHeight()
        event.preventDefault()
