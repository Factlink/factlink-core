FactlinkApp.module "Sidebar", (Sidebar, MyApp, Backbone, Marionette, $, _) ->

  Sidebar.showForChannelsOrTopicsAndActivateCorrectItem = (channels, currentChannel, user, activepage=null)->
    if user.is_current_user()
      favouriteTopics = new FavouriteTopics
      favouriteTopics.fetch()
      topicSidebarView = new TopicSidebarView
        collection: favouriteTopics
        model: user
      FactlinkApp.leftMiddleRegion.show(topicSidebarView)

      if currentChannel?
        topicSidebarView.setActiveChannel(currentChannel)
      else if activepage?
        topicSidebarView.setActive(activepage)
      else
        topicSidebarView.unsetActive()
    else
      username = user.get('username')
      window.Channels.setUsernameAndRefreshIfNeeded(username)

      channelCollectionView = new ChannelsView
        collection: channels
        model: user
      FactlinkApp.leftMiddleRegion.show(channelCollectionView)

      if currentChannel?
        channelCollectionView.setActiveChannel(currentChannel)
      else if activepage?
        channelCollectionView.setActive(activepage)
      else
        channelCollectionView.unsetActive()
