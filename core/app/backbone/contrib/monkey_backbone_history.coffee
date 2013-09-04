# See DiscussionModalOnFrontend for how this hack works.
# WARNING: be very careful when changing this stuff, there are many edge cases!

window.addBackboneHistoryCallbacksForDiscussionModal = ->

  old_navigate = Backbone.History.prototype.navigate
  Backbone.History.prototype.navigate = (fragment) ->
    fragment = @getFragment(fragment || '') # copied from Backbone

    FactlinkApp.DiscussionModalOnFrontend.setBackgroundPageUrlFromNavigate(fragment)
    old_navigate.apply this, arguments


  old_loadUrl = Backbone.History.prototype.loadUrl
  Backbone.History.prototype.loadUrl = (fragmentOverride) ->
    fragment = @getFragment(fragmentOverride) # copied from Backbone
    return if FactlinkApp.DiscussionModalOnFrontend.closeDiscussionAndAlreadyOnBackgroundPage(fragment)

    FactlinkApp.DiscussionModalOnFrontend.setBackgroundPageUrlFromLoadUrl(fragment)
    old_loadUrl.apply this, arguments
