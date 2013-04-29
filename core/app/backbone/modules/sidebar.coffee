FactlinkApp.module "Sidebar", (Sidebar, MyApp, Backbone, Marionette, $, _) ->

  Sidebar.showForChannelsOrTopicsAndActivateCorrectItem = (channels, currentChannel, user)->
    if user.is_current_user()
      @showForTopicsAndActivateCorrectItem(currentChannel?.topic(), user)
    else
      @showForChannelsAndActivateCorrectItem(channels, currentChannel, user)

  Sidebar.showForTopicsAndActivateCorrectItem = (topic, user)->
    @setUsernameOnWindowChannels(user)
    favouriteTopics = currentUser.favourite_topics
    favouriteTopics.fetch()
    @sidebarView = new TopicSidebarView
      collection: favouriteTopics
      model: user
    FactlinkApp.leftMiddleRegion.show @sidebarView

    @activateTopic topic

  Sidebar.showForChannelsAndActivateCorrectItem = (channels, currentChannel, user) ->
    @setUsernameOnWindowChannels(user)
    channelCollectionView = new ChannelsView
      collection: channels
      model: user
    FactlinkApp.leftMiddleRegion.show(channelCollectionView)

    channelCollectionView.setActiveChannel(currentChannel)

  # TODO: why is this done here, move to controller
  Sidebar.setUsernameOnWindowChannels = (user) ->
    username = user.get('username')
    window.Channels.setUsernameAndRefreshIfNeeded(username)

  Sidebar.activateTopic = (topic) ->
    @sidebarView.setActiveTopic(topic)

  Sidebar.activate = (type) ->
    @sidebarView.setActive(type)
