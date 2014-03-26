saved_marginRight = null
saved_overflow = null
html = document.documentElement
body = document.body

FactlinkJailRoot.on 'modalOpened', ->
  right_margin = window.innerWidth - html.clientWidth - html.offsetLeft
  body_width = body.offsetWidth
  if right_margin > 0
    saved_marginRight = html.style.marginRight
    saved_overflow =  html.style.overflow
    html.style.marginRight = right_margin + 'px'
    html.style.overflow = 'hidden'

    width_error = body_width - body.offsetWidth

    if width_error != 0
      console.warn('browser oddness: changing right margin caused offset:',width_error, body_width, body.offsetWidth)
      # apparently firefox does this when a margin is on the html element
      right_margin -= width_error
      html.style.marginRight = right_margin + 'px'
  else
    saved_overflow =  html.style.overflow
    html.style.overflow = 'hidden'




FactlinkJailRoot.on 'modalClosed', ->
  if saved_marginRight != null
    html.style.marginRight = saved_marginRight
    saved_marginRight = null

  html.style.overflow = saved_overflow
