FactlinkJailRoot.set_position_of_element = (top, left, window, el) ->
  x = left
  y = top
  x -= 30

  if $(window).width() < (x + el.outerWidth(true) - $(window).scrollLeft())
    x = $(window).width() - el.outerWidth(true)
  else
    x = $(window).scrollLeft()  if x < $(window).scrollLeft()

  y -= 6 + el.outerHeight(true)
  if y < $(window).scrollTop()
    y = $(window).scrollTop() + el.outerHeight(true) + 14

  el.css
    top: y + "px"
    left: x + "px"
