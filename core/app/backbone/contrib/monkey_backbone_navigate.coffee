old_loadUrl = Backbone.History.prototype.loadUrl
new_loadUrl = ->
  return if FactlinkApp.DiscussionModalOnFrontend.onLoadUrl arguments...
  old_loadUrl.apply @, arguments

Backbone.History.prototype.loadUrl = new_loadUrl
