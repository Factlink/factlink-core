# HACK: We store the background page url by overwriting "navigate" (called
# when navigating from one page in our app to another page in our app using Backbone)
# and "loadUrl" (called when coming to a page from another site, directly, or
# when using the browser navigation features). We then check if the page is not the
# page of a discussion modal, using FactlinkApp.showFactRegex, and then save it as
# the current background url.
# When loading a new page (with loadUrl), we close the discussion modal, and check if
# the background page url is the same url as we're navigating to. In that case we simply
# stop calling the respective controller.

# WARNING: be very careful when changing this stuff, there are many edge cases!

FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, FactlinkApp, Backbone, Marionette, $, _) ->

  background_page_url = null
  discussionModalContainer = null

  # keep url in sync with FactsRouter
  showFactRegex = Backbone.Router::_routeToRegExp 'f/:fact_id'

  openingModalPage = (fragment) ->
    showFactRegex.test(fragment)

  modalCurrentlyOpened = ->
    discussionModalContainer?

  setBackgroundPageUrl = (fragment) ->
    background_page_url = Backbone.history.getFragment(fragment)

  DiscussionModalOnFrontend.addInitializer ->
    return if FactlinkApp.onClientApp

    FactlinkApp.vent.on 'close_discussion_modal', ->
      throw new Error 'background_page_url is null' unless background_page_url?

      Backbone.history.navigate background_page_url, true

    addBackboneHistoryCallbacksForDiscussionModal()

  DiscussionModalOnFrontend.setBackgroundPageUrlFromLoadUrl = (fragment) ->
    return if openingModalPage(fragment)

    setBackgroundPageUrl fragment

  DiscussionModalOnFrontend.setBackgroundPageUrlFromNavigate = (fragment) ->
    return if openingModalPage(fragment)
    return if modalCurrentlyOpened() # Prevent prematurely setting the url when navigating from the discussion modal

    setBackgroundPageUrl fragment

  DiscussionModalOnFrontend.setBackgroundPageUrlFromShowFact = (fragment) ->
    setBackgroundPageUrl fragment

  DiscussionModalOnFrontend.closeDiscussionAndAlreadyOnBackgroundPage = (fragment) ->
    return false unless modalCurrentlyOpened()
    return false if openingModalPage(fragment)

    DiscussionModalOnFrontend.closeDiscussion()

    fragment == background_page_url

  DiscussionModalOnFrontend.openDiscussion = (fact) ->
    Backbone.history.navigate fact.get('url'), false

    unless discussionModalContainer
      discussionModalContainer = new DiscussionModalContainer
      FactlinkApp.discussionModalRegion.show discussionModalContainer

    discussionModalContainer.mainRegion.show new DiscussionView model: fact

  DiscussionModalOnFrontend.closeDiscussion = ->
    discussionModalContainer.fadeOut ->
      FactlinkApp.discussionModalRegion.close()

    discussionModalContainer = null

    FactlinkApp.ModalWindowContainer.close()

