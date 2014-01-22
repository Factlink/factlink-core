# See DiscussionSidebarOnFrontend for how this hack works.
# WARNING: be very careful when changing this stuff, there are many edge cases!

window.addBackboneHistoryCallbacksForDiscussionSidebar = ->

  old_navigate = Backbone.History.prototype.navigate
  Backbone.History.prototype.navigate = (fragment) ->
    fragment = @getFragment(fragment || '') # copied from Backbone

    FactlinkApp.DiscussionSidebarOnFrontend.setBackgroundPageUrlFromNavigate(fragment)
    old_navigate.apply this, arguments


  old_loadUrl = Backbone.History.prototype.loadUrl
  Backbone.History.prototype.loadUrl = (fragmentOverride) ->
    fragment = @fragment = @getFragment(fragmentOverride) # copied from Backbone
    return true if FactlinkApp.DiscussionSidebarOnFrontend.closeDiscussionAndAlreadyOnBackgroundPage(fragment)

    FactlinkApp.DiscussionSidebarOnFrontend.setBackgroundPageUrlFromLoadUrl(fragment)
    old_loadUrl.apply this, arguments
