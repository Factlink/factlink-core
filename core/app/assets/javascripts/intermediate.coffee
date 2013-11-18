showFrame = document.getElementById("frame")
xdm = window.easyXDM.noConflict("FACTLINK")
last_created_text = null
window.remote = new xdm.Rpc {},
  remote:
    hide: {}
    show: {}
    highlightNewFactlink: {}
    stopHighlightingFactlink: {}
    createdNewFactlink: {}
    trigger: {}
    setFeatureToggles: {}

  local:
    showFactlink: (id, successFn) ->
      url = "/client/facts/#{id}"
      showUrl url, successFn
      return # don't return anything unless you have a callback on the other site of easyXdm

    prepareNewFactlink: (text, siteUrl, siteTitle, guided, successFn, errorFn) ->
      url = "/facts/new" +
              "?fact=" + encodeURIComponent(text) +
              "&url=" + encodeURIComponent(siteUrl) +
              "&title=" + encodeURIComponent(siteTitle) +
              "&guided=" + encodeURIComponent(guided) +
              "&layout=client" # layout=client is still necessary to get the client sign in page
      showUrl url, successFn
      last_created_text = text
      return # don't return anything unless you have a callback on the other site of easyXdm

window.highlightLastCreatedFactlink = (id, text) ->
  if last_created_text == text
    remote.highlightNewFactlink(text, id)

showUrl = (url, successFn) ->
  window.onModalReady = ->
    window.onModalReady = ->
    successFn()

  loadUrl url

loadUrl = (url)->
  backbone = showFrame.contentWindow.Backbone
  history = backbone?.history
  if history && backbone.History.started
    history.navigate url, true
  else
    showFrame.src = url

showFrame.onload = -> window.onModalReady?()
showFrame.src = '/client/blank'
