# WARNING: be very careful when changing this stuff, there are many edge cases!

# Add a default clickhandler so we can use hrefs
Backbone.View::defaultClickHandler = (e, routeTo=null) ->
  routeTo ||= $(e.target).closest("a").attr("href")

  if e.metaKey or e.ctrlKey or e.altKey
    window.open routeTo, "_blank"
  else if not Backbone.History.started # Capitalization in Backbone.[H]istory is intentional
    window.open routeTo, FactlinkApp.linkTarget
  else
    Backbone.View::navigateTo routeTo
  e.preventDefault()
  false

Backbone.View::navigateTo = (routeTo) ->
  if "/" + Backbone.history.fragment is routeTo
    # Allow reloads by clicking links without polluting the history
    Backbone.history.fragment = null
    Backbone.history.navigate routeTo,
      trigger: true
      replace: true
  else
    if Backbone.history.loadUrl(routeTo) # Try if there is a Backbone route available
      Backbone.history.fragment = null # Force creating a state in the history
      Backbone.history.navigate routeTo, false
    else
      window.open routeTo, FactlinkApp.linkTarget
      window.focus()

# HACK: this is needed because internal events did not seem to work
$(document).on "click", ":not(body.client) a[rel=backbone]", Backbone.View::defaultClickHandler
