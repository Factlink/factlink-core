FactlinkJailRoot.createFactFromSelection = ->
  success = ->
    FactlinkJailRoot.createButton.hide()
    FactlinkJailRoot.off 'modalOpened', success

  selInfo = FactlinkJailRoot.getSelectionInfo()

  text = selInfo.text
  siteUrl = FactlinkJailRoot.siteUrl()
  siteTitle = selInfo.title

  FactlinkJailRoot.on 'modalOpened', success
  FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink', text, siteUrl, siteTitle

# We make this a global function so it can be used for direct adding of facts
# (Right click with chrome-extension)
FactlinkJailRoot.getSelectionInfo = ->
  text: window.document.getSelection().toString()
  title: window.document.title
