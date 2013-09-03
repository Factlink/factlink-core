window.addBackboneHistoryCallbacksForDiscussionModal = ->

  old_navigate = Backbone.History.prototype.navigate
  Backbone.History.prototype.navigate = (fragment) ->
    fragment = @getFragment(fragment || '') # copied from Backbone

    FactlinkApp.DiscussionModalOnFrontend.setBackgroundPageUrlCallback(fragment) &&
      old_navigate.apply this, arguments


  old_loadUrl = Backbone.History.prototype.loadUrl
  Backbone.History.prototype.loadUrl = (fragmentOverride) ->
    fragment = @getFragment(fragmentOverride) # copied from Backbone

    FactlinkApp.DiscussionModalOnFrontend.onLoadAbortIfAlreadyOnBackgroundPageCallback(fragment) &&
      FactlinkApp.DiscussionModalOnFrontend.setBackgroundPageUrlCallback(fragment) &&
      old_loadUrl.apply this, arguments
