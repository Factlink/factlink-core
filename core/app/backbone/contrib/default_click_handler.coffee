# WARNING: be very careful when changing this stuff, there are many edge cases!

# Add a default clickhandler so we can use hrefs
Backbone.View::defaultClickHandler = (e, routeTo=null) ->
  routeTo ||= $(e.target).closest("a").attr("href")

  # Return if a modifier key is pressed or when Backbone has not properly been initialized
  # Make sure we return "true" so other functions can determine what happened
  if e.metaKey or e.ctrlKey or e.altKey
    window.open routeTo, "_blank"
  else if not Backbone.History.started # Capitalization in Backbone.[H]istory is intentional
    window.open routeTo, FactlinkApp.linkTarget
  else
    Backbone.View::navigateTo routeTo
  e.preventDefault()
  false

Backbone.View::navigateTo = (routeTo) ->
  console.info "Navigating to " + routeTo, "from /" + Backbone.history.fragment
  if "/" + Backbone.history.fragment is routeTo
    # Allow reloads by clicking links without polluting the history
    Backbone.history.fragment = null
    Backbone.history.navigate routeTo,
      trigger: true
      replace: true
  else
    oldFragment = Backbone.history.fragment
    Backbone.history.navigate routeTo, false
    unless Backbone.history.loadUrl(routeTo)
      Backbone.history.navigate oldFragment, false
      window.open routeTo, FactlinkApp.linkTarget
      window.focus()

# HACK: this is needed because internal events did not seem to work
$(document).on "click", ":not(body.client) a[rel=backbone]", Backbone.View::defaultClickHandler
