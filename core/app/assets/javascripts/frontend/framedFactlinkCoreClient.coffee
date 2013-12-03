window.initClientCommunicator = ->
  last_created_text = null

  local =
    showFactlink: (id) -> showUrl "/client/facts/#{id}"

    prepareNewFactlink: (text, siteUrl, siteTitle, guided) ->
      last_created_text = text
      showUrl "/facts/new" +
        "?fact=" + encodeURIComponent(text) +
        "&url=" + encodeURIComponent(siteUrl) +
        "&title=" + encodeURIComponent(siteTitle) +
        "&guided=" + encodeURIComponent(guided)

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
