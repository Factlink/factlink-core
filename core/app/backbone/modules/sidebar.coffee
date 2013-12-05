FactlinkApp.module "Sidebar", (Sidebar, FactlinkApp, Backbone, Marionette, $, _) ->

  Sidebar.showForChannelsOrTopicsAndActivateCorrectItem = (channels, currentChannel, user)->
    if user.is_current_user()
      @showForTopicsAndActivateCorrectItem(currentChannel?.topic())
    else
      @showForChannelsAndActivateCorrectItem(channels, currentChannel)

  Sidebar.showForTopicsAndActivateCorrectItem = (topic)->
    currentUser.favourite_topics.fetch()
    @sidebarView = new TopicSidebarView collection: currentUser.favourite_topics
    FactlinkApp.leftMiddleRegion.show @sidebarView

    @activateTopic topic

  Sidebar.showForChannelsAndActivateCorrectItem = (channels, currentChannel) ->
    FactlinkApp.leftMiddleRegion.close()

  Sidebar.activateTopic = (topic) ->
    @sidebarView.setActiveTopic(topic)

  Sidebar.activate = (type) ->
    @sidebarView.setActive(type)
