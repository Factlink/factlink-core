window.initClientCommunicator = ->
  local =
    showFactlink: (id) -> showUrl "/client/facts/#{id}"

    prepareNewFactlink: (displaystring, url, fact_title, current_user_opinion) ->
      showUrl "/client/facts/new" +
        "?displaystring=" + encodeURIComponent(displaystring) +
        "&url=" + encodeURIComponent(url) +
        "&fact_title=" + encodeURIComponent(fact_title) +
        "&current_user_opinion=" + encodeURIComponent(current_user_opinion)

  showUrl = (url) ->
    # Force (re)loading the url, even if already showing that url
    # If history.fragment is equal to the current url, it doesn't reload,
    # so we reset it to null
    Backbone.history.fragment = null

    Backbone.history.navigate url, trigger: true

  Factlink.createReceiverEnvoy local

  Factlink.createSenderEnvoy window.parent

