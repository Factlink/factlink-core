getTextRange = ->
  doc = window.document
  if doc.getSelection
    doc.getSelection()
  else if doc.selection
    doc.selection.createRange().text
  else
    ''

FACTLINK.createFactFromSelection = (errorCallback) ->
  success = ->
    FACTLINK.modal.show.method()
    FACTLINK.trigger "modalOpened"
    FACTLINK.prepare.stopLoading()

  error = (e) ->
    console.error "Error openening modal: ", e
    errorCallback?()

  selInfo = FACTLINK.getSelectionInfo()

  text = selInfo.text
  siteUrl = FACTLINK.siteUrl()
  siteTitle = selInfo.title
  guided = !!FactlinkConfig.guided
  FACTLINK.remote.prepareNewFactlink text, siteUrl, siteTitle, guided, success, error

# We make this a global function so it can be used for direct adding of facts
# (Right click with chrome-extension)
FACTLINK.getSelectionInfo = ->
  text: getTextRange().toString()
  title: window.document.title
