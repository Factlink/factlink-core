html = document.documentElement
body = document.body

undo_stack = []
prop_saver = (obj, prop) ->
  (newval) ->
    oldval = obj[prop]
    undo_stack.push -> obj[prop] = oldval
    obj[prop] = newval
    oldval

restore_everything = ->
  while undo_stack.length
    undo_stack.pop()()

html_marginRight = prop_saver html.style, 'marginRight'
html_overflow = prop_saver html.style, 'overflow'
body_overflow = prop_saver body.style, 'overflow'

FactlinkJailRoot.on 'modalOpened', ->
  debugger
  right_margin = window.innerWidth - html.clientWidth - html.offsetLeft
  body_width = body.offsetWidth
  if right_margin > 0
    html_marginRight right_margin + 'px'
    html_overflow 'hidden'
    body_overflow 'visible'

    width_error = body_width - body.offsetWidth

    if width_error != 0
      console.warn('browser oddness: changing right margin caused offset:',width_error, body_width, body.offsetWidth)
      # apparently firefox does this when a margin is on the html element
      right_margin -= width_error
      html_marginRight right_margin + 'px'
  else
    html_overflow 'hidden'
    body_overflow 'visible'


FactlinkJailRoot.on 'modalClosed', restore_everything
