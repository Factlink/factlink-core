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

  DiscussionModalOnFrontend.initializer = ->
    background_page_url = currentUser.streamLink()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      Backbone.history.navigate background_page_url, true

    old_navigate = Backbone.History.prototype.navigate
    Backbone.History.prototype.navigate = (fragment) ->
      DiscussionModalOnFrontend.setBackgroundPageUrl fragment
      old_navigate.apply @, arguments

    old_loadUrl = Backbone.History.prototype.loadUrl
    Backbone.History.prototype.loadUrl = (fragment) ->
      sanitized_fragment = Backbone.history.getFragment(fragment)
      already_on_the_background_page = (sanitized_fragment == background_page_url)

      DiscussionModalOnFrontend.setBackgroundPageUrl fragment

      if FactlinkApp.discussionModalRegion.currentView?
        FactlinkApp.discussionModalRegion.close()
        FactlinkApp.ModalWindowContainer.close()
        return if already_on_the_background_page

      old_loadUrl.apply @, arguments


  DiscussionModalOnFrontend.openDiscussion = (fact) ->
    Backbone.history.navigate fact.get('url'), false

    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.setBackgroundPageUrl = (fragment) ->
    sanitized_fragment = Backbone.history.getFragment(fragment)
    unless FactlinkApp.showFactRegex.test sanitized_fragment
      background_page_url = sanitized_fragment
