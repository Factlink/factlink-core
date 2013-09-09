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
    Factlink.prepare.stopLoading()

  error = (e) ->
    console.error "Error openening modal: ", e
    errorCallback?()

  selInfo = Factlink.getSelectionInfo()
  Factlink.remote.prepareNewFactlink selInfo.text, Factlink.siteUrl(), selInfo.title, !!FactlinkConfig.guided, success, error

# We make this a global function so it can be used for direct adding of facts
# (Right click with chrome-extension)
Factlink.getSelectionInfo = ->
  text: getTextRange().toString()
  title: window.document.title
