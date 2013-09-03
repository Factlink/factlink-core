# We also want an event when a new url is loaded,
# e.g. when navigating using the browser
old_loadUrl = Backbone.History.prototype.loadUrl
new_loadUrl = (fragment, options) ->
  FactlinkApp.vent.trigger 'load_url', fragment
  old_loadUrl.apply @, arguments

Backbone.History.prototype.loadUrl = new_loadUrl
