FactlinkApp.module "Sidebar", (Sidebar, FactlinkApp, Backbone, Marionette, $, _) ->

  Sidebar.showForChannelsOrTopicsAndActivateCorrectItem = (user) ->
    if user.is_current_user()
      @showForTopicsAndActivateCorrectItem()
    else
      FactlinkApp.leftMiddleRegion.close()

  Sidebar.showForTopicsAndActivateCorrectItem = (topic) ->
    currentUser.favourite_topics.fetch()
    @sidebarView = new TopicSidebarView collection: currentUser.favourite_topics
    FactlinkApp.leftMiddleRegion.show @sidebarView

    @activateTopic topic

  Sidebar.activateTopic = (topic) ->
    @sidebarView.setActiveTopic(topic)

  Sidebar.activate = (type) ->
    @sidebarView.setActive(type)
