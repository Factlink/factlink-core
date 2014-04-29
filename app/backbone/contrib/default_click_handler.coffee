# WARNING: be very careful when changing this stuff, there are many edge cases!

# Add a default clickhandler so we can use hrefs
defaultClickHandler = (e) ->
  #handle clicks when...
  if !(e.metaKey || e.ctrlKey || e.altKey)  # no user-new-tab-keys are pressed
    $link = $(e.target).closest("a")
    if !$link.attr("target") && $link.attr("rel") == 'backbone' && $link.attr("href") # and there's real link without target
      if navigateTo($link.attr("href")) # and it's routable via backbone
        e.preventDefault() #if we handle clicks, abort browser default.

navigateTo = (url) ->
  status = Backbone.history.navigate(url, true)
  if status == undefined #means url unchanged; nothing happened.
    Backbone.history.loadUrl(url) #reload on navigate to current location.
  else
    status
$(document).on "click", defaultClickHandler
