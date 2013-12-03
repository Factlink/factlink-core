window.initClientCommunicator = ->
  last_created_text = null

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

  Factlink.createReceiverEnvoy local

  annotatedSiteEnvoy = Factlink.createSenderEnvoy window.parent,
    ['modalFrameReady', 'openModalOverlay', 'closeModal_noAction',  'closeModal_highlightNewFactlink', 'closeModal_deleteFactlink'
    ]

  highlightLastCreatedFactlink = (fact_id, fact_text) ->
    if last_created_text == fact_text
      annotatedSiteEnvoy.closeModal_highlightNewFactlink(fact_text, fact_id)

  showUrl = (url) ->
    # Force (re)loading the url, even if already showing that url
    # If history.fragment is equal to the current url, it doesn't reload,
    # so we reset it to null
    Backbone.history.fragment = null

    Backbone.history.navigate url, trigger: true

  window.clientCommunicator =
    highlightLastCreatedFactlink: highlightLastCreatedFactlink
    annotatedSiteEnvoy: annotatedSiteEnvoy
