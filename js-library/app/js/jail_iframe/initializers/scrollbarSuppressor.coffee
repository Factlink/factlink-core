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
FactlinkJailRoot.on 'modalOpened', ->
  document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')
FactlinkJailRoot.on 'modalClosed', -> document.documentElement.removeAttribute('data-factlink-suppress-scrolling')
