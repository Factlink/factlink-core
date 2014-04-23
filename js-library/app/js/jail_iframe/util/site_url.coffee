FactlinkJailRoot.siteUrl = ->
  if canonicalHref = $('link[rel="canonical"]').attr('href')
    linkElement = document.createElement('a')
    linkElement.href = canonicalHref
    return linkElement.href # normalized
  else
    return window.FactlinkProxiedUri || window.location.href
