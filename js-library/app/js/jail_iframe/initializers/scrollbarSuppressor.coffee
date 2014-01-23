scrollbarWidth = 0
FactlinkJailRoot.loaded_promise.then ->
  # Create the measurement nod; see http://davidwalsh.name/detect-scrollbar-width
  scrollDiv = document.createElement("div");
  $(scrollDiv).css(
    width: "100px"
    height: "100px"
    overflow: "scroll"
    position: "absolute"
    top: "-9999px"
  )
  document.body.appendChild(scrollDiv)

  scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth

  document.body.removeChild(scrollDiv)
  console.log 'scrollbar width: ', scrollbarWidth


# To check for scrollbars on the window,  use the slightly unusual window.innerHeight
# rather than  document.documentElement.clientHeight so it works in css compat mode.
window_has_scrollbar = -> window.innerHeight < document.documentElement.scrollHeight

saved_marginRight = null

FactlinkJailRoot.on 'modalOpened', ->
  if window_has_scrollbar()
    right_margin = window.innerWidth - document.documentElement.offsetWidth - document.documentElement.offsetLeft
    html_width = document.documentElement.offsetWidth
    if right_margin > 0
      saved_marginRight = document.documentElement.style.marginRight
      document.documentElement.style.marginRight = right_margin + 'px'
      document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')
      width_error = html_width - document.documentElement.offsetWidth
      if width_error != 0
        console.warn('browser oddness: changing right margin caused offset:',width_error, html_width, document.documentElement.offsetWidth)
        # apparently firefox does this when a margin is on the html element
        right_margin -= width_error
        document.documentElement.style.marginRight = right_margin + 'px'
    else
      document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')




FactlinkJailRoot.on 'modalClosed', ->
  if saved_marginRight != null
    document.documentElement.style.marginRight = saved_marginRight
    saved_marginRight = null

  document.documentElement.removeAttribute('data-factlink-suppress-scrolling')
