window.initClientCommunicator = ->
  local =
    showFactlink: (id) -> showUrl "/client/facts/#{id}"

    prepareNewFactlink: (text, siteUrl, siteTitle, guided) ->
      showUrl "/facts/new" +
        "?fact=" + encodeURIComponent(text) +
        "&url=" + encodeURIComponent(siteUrl) +
        "&title=" + encodeURIComponent(siteTitle) +
        "&guided=" + encodeURIComponent(guided)


  showUrl = (url) ->
    # Force (re)loading the url, even if already showing that url
    # If history.fragment is equal to the current url, it doesn't reload,
    # so we reset it to null
    Backbone.history.fragment = null

    Backbone.history.navigate url, trigger: true

  Factlink.createReceiverEnvoy local

  window.annotatedSiteEnvoy = Factlink.createSenderEnvoy window.parent

