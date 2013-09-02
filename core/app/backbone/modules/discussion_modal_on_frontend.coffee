FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  last_visited_url = null

  DiscussionModalOnFrontend.addInitializer ->
    FactlinkApp.vent.on 'load_url', ->
      DiscussionModalOnFrontend.closeDiscussion()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      DiscussionModalOnFrontend.closeDiscussion()
      Backbone.history.navigate last_visited_url, false

  DiscussionModalOnFrontend.openDiscussion = (fact) ->
    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.closeDiscussion = ->
    FactlinkApp.discussionModalRegion.close()

  DiscussionModalOnFrontend.setLastVisitedUrl = (url) ->
    last_visited_url = url
