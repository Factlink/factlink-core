#= require jquery.prevent_scroll_propagation

$.fn.preventScrollPropagation = ->
  @each ->
    $(this).bind 'mousewheel', (e, d) ->
      if d > 0 && $(this).scrollTop() <= 0
        e.preventDefault()
      else if d < 0 && $(this).scrollTop() >= $(this).get(0).scrollHeight - $(this).innerHeight()
        e.preventDefault()
