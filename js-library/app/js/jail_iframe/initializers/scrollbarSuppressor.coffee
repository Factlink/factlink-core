FactlinkJailRoot.on 'modalOpened', ->
  if FactlinkJailRoot.can_haz.suppress_double_scrollbar
    document.documentElement.setAttribute('data-factlink-suppress-scrolling', '')
FactlinkJailRoot.on 'modalClosed', -> document.documentElement.removeAttribute('data-factlink-suppress-scrolling')
