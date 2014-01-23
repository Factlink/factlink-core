# HACK: We store the background page url by overwriting "navigate" (called
# when navigating from one page in our app to another page in our app using Backbone)
# and "loadUrl" (called when coming to a page from another site, directly, or
# when using the browser navigation features). We then check if the page is not the
# page of a discussion sidebar, using FactlinkApp.showFactRegex, and then save it as
# the current background url.
# When loading a new page (with loadUrl), we close the discussion sidebar, and check if
# the background page url is the same url as we're navigating to. In that case we simply
# stop calling the respective controller.

# WARNING: be very careful when changing this stuff, there are many edge cases!

FactlinkApp.module "DiscussionSidebarOnFrontend", (DiscussionSidebarOnFrontend, FactlinkApp, Backbone, Marionette, $, _) ->

  background_page_url = null
  discussionSidebarContainer = null

  # keep url in sync with FactsRouter
  showFactRegex = Backbone.Router::_routeToRegExp 'f/:fact_id'

  openingSidebarPage = (fragment) ->
    showFactRegex.test(fragment)

  sidebarCurrentlyOpened = ->
    discussionSidebarContainer.opened

  setBackgroundPageUrl = (fragment) ->
    background_page_url = Backbone.history.getFragment(fragment)

  DiscussionSidebarOnFrontend.addInitializer ->
    return if FactlinkApp.onClientApp

    discussionSidebarContainer = new DiscussionSidebarContainer
    FactlinkApp.discussionSidebarRegion.show discussionSidebarContainer

    FactlinkApp.vent.on 'close_discussion_sidebar', ->
      throw new Error 'background_page_url is null' unless background_page_url?

      Backbone.history.navigate background_page_url, true

    addBackboneHistoryCallbacksForDiscussionSidebar()

  DiscussionSidebarOnFrontend.setBackgroundPageUrlFromLoadUrl = (fragment) ->
    return if openingSidebarPage(fragment)

    setBackgroundPageUrl fragment

  DiscussionSidebarOnFrontend.setBackgroundPageUrlFromNavigate = (fragment) ->
    return if openingSidebarPage(fragment)
    return if sidebarCurrentlyOpened() # Prevent prematurely setting the url when navigating from the discussion sidebar

    setBackgroundPageUrl fragment

  DiscussionSidebarOnFrontend.setBackgroundPageUrlFromShowFact = (fragment) ->
    setBackgroundPageUrl fragment

  DiscussionSidebarOnFrontend.closeDiscussionAndAlreadyOnBackgroundPage = (fragment) ->
    return false unless sidebarCurrentlyOpened()
    return false if openingSidebarPage(fragment)

    DiscussionSidebarOnFrontend.closeDiscussion()

    fragment == background_page_url

  DiscussionSidebarOnFrontend.openDiscussion = (fact) ->
    discussionSidebarContainer.slideIn new DiscussionView model: fact
    Backbone.history.navigate fact.get('url'), false

  DiscussionSidebarOnFrontend.closeDiscussion = ->
    discussionSidebarContainer.slideOut()
    FactlinkApp.ModalWindowContainer.close()
