# HACK: We store the background page url by intercepting "navigate" (called
# when navigating from one page in our app to another page in our app using Backbone)
# and "loadUrl" (called when coming to a page from another site, directly, or
# when using the browser navigation features). We then check if the page is not the
# page of a discussion modal, using FactlinkApp.showFactRegex, and then save it as
# the current background url.
# When loading a new page (with loadUrl), we close the discussion modal, and check if
# the background page url is the same url as we're navigating to. In that case we simply
# stop calling the respective controller.

FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  background_page_url = null

  openingModalPage = (fragment) ->
    FactlinkApp.showFactRegex.test(fragment)

  modalCurrentlyOpened = ->
    FactlinkApp.discussionModalRegion.currentView?

  setBackgroundPageUrlHook = (fragment) ->
    unless openingModalPage(fragment)
      background_page_url = fragment
    true

  abortIfAlreadyOnBackgroundPageHook = (fragment) ->
    if !openingModalPage(fragment) && modalCurrentlyOpened()
      DiscussionModalOnFrontend.closeDiscussion()

      fragment != background_page_url
    else
      true

  DiscussionModalOnFrontend.addInitializer ->
    return if FactlinkApp.modal

    background_page_url = Backbone.history.getFragment currentUser.streamLink()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      Backbone.history.navigate background_page_url, true

    addBackboneHistoryNavigateHook setBackgroundPageUrlHook
    addBackboneHistoryLoadUrlHook setBackgroundPageUrlHook
    addBackboneHistoryLoadUrlHook abortIfAlreadyOnBackgroundPageHook

  DiscussionModalOnFrontend.openDiscussion = (fact) ->
    Backbone.history.navigate fact.get('url'), false

    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.closeDiscussion = ->
    FactlinkApp.discussionModalRegion.close()
    FactlinkApp.ModalWindowContainer.close()

