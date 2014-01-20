FactlinkJailRoot.on 'modalOpened', ->
  document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')
FactlinkJailRoot.on 'modalClosed', -> document.documentElement.removeAttribute('data-factlink-suppress-scrolling')
