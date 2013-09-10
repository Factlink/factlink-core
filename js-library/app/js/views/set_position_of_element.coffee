FACTLINK.set_position_of_element = (top, left, window, el) ->
  setLeft = (element) ->
    element.addClass "left"
    element.removeClass "right"
  setRight = (element) ->
    element.addClass "right"
    element.removeClass "left"
  setTop = (element) ->
    element.addClass "top"
    element.removeClass "bottom"
  setBottom = (element) ->
    element.addClass "bottom"
    element.removeClass "top"

  x = left
  y = top
  x -= 30

  if $(window).width() < (x + el.outerWidth(true) - $(window).scrollLeft())
    x = $(window).width() - el.outerWidth(true)
    setLeft el
  else
    x = $(window).scrollLeft()  if x < $(window).scrollLeft()
    setRight el

  y -= 6 + el.outerHeight(true)
  if y < $(window).scrollTop()
    y = $(window).scrollTop() + el.outerHeight(true) + 14
    setTop el
  else
    setBottom el

  el.css
    top: y + "px"
    left: x + "px"

