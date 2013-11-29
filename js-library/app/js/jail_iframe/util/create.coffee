getTextRange = ->
  doc = window.document
  if doc.getSelection
    doc.getSelection()
  else if doc.selection
    doc.selection.createRange().text
  else
    ''

Factlink.createFactFromSelection = () ->
  success = ->
    Factlink.createButton.hide()
    Factlink.off 'modalOpened', success

  selInfo = Factlink.getSelectionInfo()

  text = selInfo.text
  siteUrl = Factlink.siteUrl()
  siteTitle = selInfo.title
  guided = !!FactlinkConfig.guided

  Factlink.on 'modalOpened', success
  Factlink.remote.prepareNewFactlink text, siteUrl, siteTitle, guided

# We make this a global function so it can be used for direct adding of facts
# (Right click with chrome-extension)
Factlink.getSelectionInfo = ->
  text: getTextRange().toString()
  title: window.document.title
