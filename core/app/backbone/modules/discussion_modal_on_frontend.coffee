FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  last_visited_url = null

  DiscussionModalOnFrontend.addInitializer ->
    FactlinkApp.vent.on 'load_url', ->
      DiscussionModalOnFrontend.closeDiscussion()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      Backbone.history.navigate last_visited_url, false
      DiscussionModalOnFrontend.closeDiscussion()

  DiscussionModalOnFrontend.openDiscussion = (fact, url) ->
    Backbone.history.navigate fact.get('url'), false
    last_visited_url = url if url?
    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.closeDiscussion = ->
    FactlinkApp.discussionModalRegion.close()
