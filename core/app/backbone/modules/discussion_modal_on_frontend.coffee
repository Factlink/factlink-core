FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  background_page_url = null

  DiscussionModalOnFrontend.addInitializer ->
    background_page_url = currentUser.streamLink()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      Backbone.history.navigate background_page_url, true

  DiscussionModalOnFrontend.openDiscussion = (fact, url=background_page_url) ->
    Backbone.history.navigate fact.get('url'), false
    background_page_url = Backbone.history.getFragment(url)

    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  # This assumes that we use "navigate url, true" for all url changes that
  # originate from the discussion modal
  old_loadUrl = Backbone.History.prototype.loadUrl
  Backbone.History.prototype.loadUrl = (fragment) ->
    FactlinkApp.discussionModalRegion.close()

    sanitizedFragment = Backbone.history.getFragment(fragment)
    already_on_the_background_page = (sanitizedFragment == background_page_url)
    background_page_url = null

    already_on_the_background_page or old_loadUrl.apply @, arguments
