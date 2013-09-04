# Add a default clickhandler so we can use hrefs
Backbone.View::defaultClickHandler = (e, routeTo=null) ->
  routeTo ||= $(e.target).closest("a").attr("href")

  # Return if a modifier key is pressed or when Backbone has not properly been initialized
  # Make sure we return "true" so other functions can determine what happened
  # Note that the capitalization in Backbone.[H]istory is intentional
  if e.metaKey or e.ctrlKey or e.altKey
    window.open routeTo, "_blank"
  else if not Backbone.History.started
    window.open routeTo, FactlinkApp.linkTarget
  else
    Backbone.View::navigateTo routeTo
  e.preventDefault()
  false

Backbone.View::navigateTo = (routeTo) ->
  console.info "Navigating to " + routeTo, "from /" + Backbone.history.fragment
  if "/" + Backbone.history.fragment is routeTo
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
