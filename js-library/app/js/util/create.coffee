getTextRange = ->
  doc = window.document
  if doc.getSelection
    doc.getSelection()
  else if doc.selection
    doc.selection.createRange().text
  else
    ''

Factlink.createFactFromSelection = (errorCallback) ->
  success = ->
    Factlink.modal.show.method()
    Factlink.trigger "modalOpened"
    Factlink.createButton.hide()

  error = (e) ->
    console.error "Error openening modal: ", e
    errorCallback?()

  selInfo = Factlink.getSelectionInfo()

  text = selInfo.text
  siteUrl = Factlink.siteUrl()
  siteTitle = selInfo.title
  guided = !!FactlinkConfig.guided

  Factlink.remote.prepareNewFactlink text, siteUrl, siteTitle, guided, success, error

# We make this a global function so it can be used for direct adding of facts
# (Right click with chrome-extension)
Factlink.getSelectionInfo = ->
  text: getTextRange().toString()
  title: window.document.title
