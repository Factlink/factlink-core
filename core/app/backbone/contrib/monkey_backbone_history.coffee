window.addBackboneHistoryNavigateHook = (callback) ->
  old_navigate = Backbone.History.prototype.navigate

  Backbone.History.prototype.navigate = (fragment) ->
    fragment = @getFragment(fragment || '') # copied from Backbone

    callback(fragment) && old_navigate.apply this, arguments


window.addBackboneHistoryLoadUrlHook = (callback) ->
  old_loadUrl = Backbone.History.prototype.loadUrl

  Backbone.History.prototype.loadUrl = (fragmentOverride) ->
    fragment = @fragment = @getFragment(fragmentOverride) # copied from Backbone

    callback(fragment) && old_loadUrl.apply this, arguments
