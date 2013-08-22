#= require jquery.prevent_scroll_propagation

showFrame = document.getElementById("frame")
xdm = window.easyXDM.noConflict("FACTLINK")
window.remote = new xdm.Rpc {},
  remote:
    hide: {}
    show: {}
    highlightNewFactlink: {}
    stopHighlightingFactlink: {}
    createdNewFactlink: {}
    trigger: {}

  local:
    showFactlink: (id, successFn) ->
      url = "/facts/" + id + "?layout=client"
      showUrl url, successFn
      return # don't return anything unless you have a callback on the other site of easyXdm

    prepareNewFactlink: (text, siteUrl, siteTitle, guided, successFn, errorFn) ->
      url = "/facts/new" +
              "?fact=" + encodeURIComponent(text) +
              "&url=" + encodeURIComponent(siteUrl) +
              "&title=" + encodeURIComponent(siteTitle) +
              "&guided=" + encodeURIComponent(guided) +
              "&layout=client"
      showUrl url, successFn

      onFactlinkCreated = (e, id) ->
        remote.highlightNewFactlink text, id

      $(document).on "factlinkCreated", (e, id, created_text) ->
        onFactlinkCreated(e, id) if created_text == text

      return # don't return anything unless you have a callback on the other site of easyXdm

    position: (top, left) ->
      try
        showFrame.contentWindow.position top, left
      catch e # Window not yet loaded
        showFrame.onload = ->
          showFrame.contentWindow.position top, left
      return # don't return anything unless you have a callback on the other site of easyXdm

showUrl = (url, successFn) ->
  successCalled = 0
  onLoadSuccess = ->
    unless successCalled
      successCalled++
      successFn()  if $.isFunction(successFn)

  showFrame.onload = onLoadSuccess
  # Somehow only lower case letters seem to work for those events --mark
  $(document).on "modalready", onLoadSuccess
  loadUrl url
  showFrame.className = "overlay"

loadUrl = (url)->
  backbone = showFrame.contentWindow.Backbone
  history = backbone?.history
  if history? and backbone.History.started
    history.loadUrl url
  else
    showFrame.src = url

# initialize the page, so we are ready to render new pages fast
loadUrl '/facts/new?layout=client'

$("iframe").preventScrollPropagation()
$("iframe").on 'click', (e) -> e.stopPropagation()
