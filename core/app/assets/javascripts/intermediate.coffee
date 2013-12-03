#= require postFactlinkObject

showFrame = document.getElementById("frame")
last_created_text = null

window.remote = Factlink.createFrameProxyObject window.parent,
  ['modalFrameReady', 'openModalOverlay', 'closeModal_noAction',  'closeModal_highlightNewFactlink', 'closeModal_deleteFactlink'
  ]

local =
    showFactlink: (id) ->
      url = "/client/facts/#{id}"
      showUrl url

    prepareNewFactlink: (text, siteUrl, siteTitle, guided) ->
      url = "/facts/new" +
              "?fact=" + encodeURIComponent(text) +
              "&url=" + encodeURIComponent(siteUrl) +
              "&title=" + encodeURIComponent(siteTitle) +
              "&guided=" + encodeURIComponent(guided)
      showUrl url
      last_created_text = text

Factlink.listenToWindowMessages local

window.highlightLastCreatedFactlink = (fact_id, fact_text) ->
  if last_created_text == fact_text
    remote.closeModal_highlightNewFactlink(fact_text, fact_id)

showUrl = (url) ->
  backbone = showFrame.contentWindow.Backbone
  history = backbone?.history
  if history && backbone.History.started
    # Force (re)loading the url, even if already showing that url
    # If history.fragment is equal to the current url, it doesn't reload,
    # so we reset it to null
    history.fragment = null

    history.navigate url, trigger: true
  else
    showFrame.onload = -> window.remote.openModalOverlay()
    showFrame.src = url

showFrame.src = '/client/blank'
