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
              "&guided=" + encodeURIComponent(guided)
      showUrl url, successFn
      last_created_text = text
      return # don't return anything unless you have a callback on the other site of easyXdm

window.highlightLastCreatedFactlink = (id, text) ->
  if last_created_text == text
    remote.highlightNewFactlink(text, id)

showUrl = (url, successFn) ->
  window.onModalReady = ->
    window.onModalReady = -> # nothing
    successFn()

  backbone = showFrame.contentWindow.Backbone
  history = backbone?.history
  if history && backbone.History.started
    # Force (re)loading the url, even if already showing that url
    # If history.fragment is equal to the current url, it doesn't reload,
    # so we reset it to null
    history.fragment = null

    history.navigate url, trigger: true
  else
    showFrame.onload = -> window.onModalReady()
    showFrame.src = url

showFrame.src = '/client/blank'
