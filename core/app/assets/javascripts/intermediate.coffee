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

    position: (top, left) ->
      try
        showFrame.contentWindow.position top, left
      catch e # Window not yet loaded
        showFrame.onload = ->
          showFrame.contentWindow.position top, left
      return # don't return anything unless you have a callback on the other site of easyXdm

window.highlightLastCreatedFactlink = (id, text) ->
  if last_created_text == text
    remote.highlightNewFactlink(text, id)

showUrl = (url, successFn) ->
  window.onModalReady = $.noop
  if $.isFunction(successFn)
    window.onModalReady = ->
      window.onModalReady = $.noop
      successFn()

  loadUrl url
  showFrame.className = "overlay"

loadUrl = (url)->
  backbone = showFrame.contentWindow.Backbone
  history = backbone?.history
  if history && backbone.History.started
    history.loadUrl url
  else
    showFrame.src = url

showFrame.onload = -> window.onModalReady()

# initialize the page, so we are ready to render new pages fast
loadUrl '/client/blank'
