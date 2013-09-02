# We also want an event when a new url is loaded,
# e.g. when navigating using the browser
old_loadUrl = Backbone.History.prototype.loadUrl
new_loadUrl = ->
  return if FactlinkApp.DiscussionModalOnFrontend.onLoadUrl arguments...

  FactlinkApp.vent.trigger 'load_url'
  old_loadUrl.apply @, arguments

Backbone.History.prototype.loadUrl = new_loadUrl
