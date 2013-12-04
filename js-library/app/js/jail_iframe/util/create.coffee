getTextRange = ->
  doc = window.document
  if doc.getSelection
    doc.getSelection()
  else if doc.selection
    doc.selection.createRange().text
  else
    ''

FactlinkJailRoot.createFactFromSelection = () ->
  success = ->
    FactlinkJailRoot.createButton.hide()
    FactlinkJailRoot.off 'modalOpened', success

  selInfo = FactlinkJailRoot.getSelectionInfo()

  text = selInfo.text
  siteUrl = FactlinkJailRoot.siteUrl()
  siteTitle = selInfo.title
  guided = !!FactlinkConfig.guided

  FactlinkJailRoot.on 'modalOpened', success
  FactlinkJailRoot.factlinkCoreEnvoy 'prepareNewFactlink', text, siteUrl, siteTitle, guided

# We make this a global function so it can be used for direct adding of facts
# (Right click with chrome-extension)
FactlinkJailRoot.getSelectionInfo = ->
  text: getTextRange().toString()
  title: window.document.title
