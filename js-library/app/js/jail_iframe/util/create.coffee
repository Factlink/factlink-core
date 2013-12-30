FactlinkJailRoot.createFactFromSelection = ->
  success = ->
    FactlinkJailRoot.createButton.hide()
    FactlinkJailRoot.off 'modalOpened', success

  selInfo =
    text: window.document.getSelection().toString()
    title: window.document.title

  text = selInfo.text
  siteUrl = FactlinkJailRoot.siteUrl()
  siteTitle = selInfo.title

  FactlinkJailRoot.on 'modalOpened', success
  FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink', text, siteUrl, siteTitle

FactlinkJailRoot.textSelected = ->
  !!window.document.getSelection().toString()
