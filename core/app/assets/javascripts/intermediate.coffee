#= require jquery
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
      successCalled = 0
      onLoadSuccess = ->
        unless successCalled
          successCalled++
          successFn()

      showFrame.onload = onLoadSuccess
      # Somehow only lower case letters seem to work for those events --mark
      $(document).bind "modalready", onLoadSuccess
      showFrame.src = "/facts/" + id + "?layout=client"
      showFrame.className = "overlay"
      return # don't return anything unless you have a callback on the other site of easyXdm

    prepareNewFactlink: (text, siteUrl, siteTitle, guided, successFn, errorFn) ->
      successCalled = 0
      onLoadSuccess = ->
        unless successCalled
          successCalled++
          successFn()  if $.isFunction(successFn)

      showFrame.onload = onLoadSuccess
      # Somehow only lower case letters seem to work for those events --mark
      $(document).bind "modalready", onLoadSuccess
      showFrame.src = "/facts/new" + "?fact=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(siteUrl) + "&title=" + encodeURIComponent(siteTitle) + "&guided=" + encodeURIComponent(guided) + "&layout=client"
      showFrame.className = "overlay"
      onFactlinkCreated = (e, id) ->
        remote.highlightNewFactlink text, id

      $(document).bind "factlinkCreated", onFactlinkCreated
      return # don't return anything unless you have a callback on the other site of easyXdm

    position: (top, left) ->
      try
        showFrame.contentWindow.position top, left
      catch e # Window not yet loaded
        showFrame.onload = ->
          showFrame.contentWindow.position top, left
      return # don't return anything unless you have a callback on the other site of easyXdm

$("iframe").preventScrollPropagation()
