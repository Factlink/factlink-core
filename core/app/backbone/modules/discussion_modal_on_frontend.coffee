FactlinkApp.module "DiscussionModalOnFrontend", (DiscussionModalOnFrontend, MyApp, Backbone, Marionette, $, _) ->

  background_page_url = null

  DiscussionModalOnFrontend.addInitializer ->
    background_page_url = currentUser.streamLink()

    FactlinkApp.vent.on 'close_discussion_modal', ->
      Backbone.history.navigate background_page_url, true

  DiscussionModalOnFrontend.openDiscussion = (fact) ->
    Backbone.history.navigate fact.get('url'), false

    newClientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show newClientModal
    newClientModal.mainRegion.show new NDPDiscussionView model: fact

  DiscussionModalOnFrontend.setBackgroundPageUrl = (fragment) ->
    sanitized_fragment = Backbone.history.getFragment(fragment)
    unless FactlinkApp.showFactRegex.test sanitized_fragment
      background_page_url = sanitized_fragment

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
      return if already_on_the_background_page

    old_loadUrl.apply @, arguments
