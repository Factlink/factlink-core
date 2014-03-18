FactlinkJailRoot.createFactFromSelection = ->
  text = window.document.getSelection().toString().trim()
  siteTitle = window.document.title
  siteUrl = FactlinkJailRoot.siteUrl()
  window.document.getSelection().removeAllRanges()
  FactlinkJailRoot.createButton.hide()

  FactlinkJailRoot.openModalOverlay()
  FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink',
    text, siteUrl, siteTitle

FactlinkJailRoot.textSelected = ->
  # At least 3 words of at least 2 characters, separated by at most 6 non-letter chars
  /(\w{2,}\W{1,6}){3}/.test window.document.getSelection().toString()
