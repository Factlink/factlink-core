# We want an event whenever we change the url of
# the page

old_navigate = Backbone.History.prototype.navigate
new_navigate = (fragment, options) ->
  FactlinkApp.vent.trigger 'navigate'
  old_navigate.apply @, arguments

Backbone.History.prototype.navigate = new_navigate


# We also want an event when a new url is loaded,
# e.g. when navigating using the browser
old_loadUrl = Backbone.History.prototype.loadUrl
new_loadUrl = (fragment, options) ->
  FactlinkApp.vent.trigger 'load_url'
  old_loadUrl.apply @, arguments

Backbone.History.prototype.loadUrl = new_loadUrl
