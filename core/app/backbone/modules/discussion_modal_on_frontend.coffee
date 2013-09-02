FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  urls = []

  DiscussionModalOnFrontend.addInitializer ->
    FactlinkApp.vent.on 'load_url', (url) ->
      urls.push url
      DiscussionModalOnFrontend.closeDiscussion()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      url = urls.pop() || currentUser.streamLink()
      urls = []
      DiscussionModalOnFrontend.closeDiscussion()
      Backbone.history.navigate url, false

  DiscussionModalOnFrontend.openDiscussion = (fact) ->
    urls.pop()

    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.closeDiscussion = ->
    FactlinkApp.discussionModalRegion.close()
