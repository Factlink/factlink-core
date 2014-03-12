# WARNING: be very careful when changing this stuff, there are many edge cases!

# Add a default clickhandler so we can use hrefs
defaultClickHandler = (e) ->
  if Backbone.History.started # Capitalization in Backbone.[H]istory is intentional
    $link = $(e.target).closest("a")
    url = $link.attr("href")

    target = $link.attr("target")
    if e.metaKey or e.ctrlKey or e.altKey
      target = "_blank"

    if target?
      window.open url, target
    else
      navigateTo url, $link.attr("target")

    false # prevent default
  else
    true

navigateTo = (url, target='_self') ->
  if "/" + Backbone.history.fragment is url
    # Allow reloads by clicking links without polluting the history
    Backbone.history.fragment = null
    Backbone.history.navigate url,
      trigger: true
      replace: true
  else
    if Backbone.history.loadUrl(url) # Try if there is a Backbone route available
      Backbone.history.fragment = null # Force creating a state in the history
      Backbone.history.navigate url, false
    else
      window.open url, target
      window.focus()

# HACK: this is needed because internal events did not seem to work
$(document).on "click", ":not(body.client) a[rel=backbone]", defaultClickHandler
