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

  # HACK: This assumes that we use "navigate url, true" for all url changes that
  # originate from the discussion modal
    FactlinkApp.discussionModalRegion.close()

    if fragment == background_page_url
      background_page_url = null
      true
    else
      background_page_url = null
      false
