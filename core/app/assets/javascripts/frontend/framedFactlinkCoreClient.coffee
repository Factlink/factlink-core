window.initClientCommunicator = ->
  if !window.parent || window == window.parent
    return ->

  local =
    showFactlink: (id) -> showUrl "/client/facts/#{id}"

    prepareNewFactlink: (displaystring, url, site_title, current_user_opinion='no_vote') ->
      showUrl "/client/facts/new" +
        "?displaystring=" + encodeURIComponent(displaystring) +
        "&url=" + encodeURIComponent(url) +
        "&site_title=" + encodeURIComponent(site_title) +
        "&current_user_opinion=" + encodeURIComponent(current_user_opinion)

  showUrl = (url) ->
    # Force (re)loading the url, even if already showing that url
    # If history.fragment is equal to the current url, it doesn't reload,
    # so we reset it to null
    Backbone.history.fragment = null

    Backbone.history.navigate url, trigger: true

  Factlink.createReceiverEnvoy local

  Factlink.createSenderEnvoy window.parent
