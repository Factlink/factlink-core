# WARNING: be very careful when changing this stuff, there are many edge cases!

# Add a default clickhandler so we can use hrefs
defaultClickHandler = (e) ->
  url = $(e.target).closest("a").attr("href")

  if e.metaKey or e.ctrlKey or e.altKey
    window.open url, "_blank"
  else if not Backbone.History.started # Capitalization in Backbone.[H]istory is intentional
    window.open url
  else
    navigateTo url
  e.preventDefault()
  false

navigateTo = (url) ->
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
      window.open url
      window.focus()

# HACK: this is needed because internal events did not seem to work
$(document).on "click", ":not(body.client) a[rel=backbone]", defaultClickHandler
