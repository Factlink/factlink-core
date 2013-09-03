FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  background_page_url = null

  DiscussionModalOnFrontend.addInitializer ->
    FactlinkApp.vent.on 'route', ->
      DiscussionModalOnFrontend.closeDiscussion()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      Backbone.history.navigate background_page_url, false
      DiscussionModalOnFrontend.closeDiscussion()

  DiscussionModalOnFrontend.openDiscussion = (fact, url) ->
    Backbone.history.navigate fact.get('url'), false
    background_page_url = url if url?
    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.closeDiscussion = ->
    FactlinkApp.discussionModalRegion.close()
