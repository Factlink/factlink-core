FactlinkApp.module "Sidebar", (Sidebar, MyApp, Backbone, Marionette, $, _) ->

  Sidebar.showForChannelsOrTopicsAndActivateCorrectItem = (channels, currentChannel, user)->
    if user.is_current_user()
      favouriteTopics = new FavouriteTopics
      favouriteTopics.fetch()
      topicSidebarView = new TopicSidebarView
        collection: favouriteTopics
        model: user
      FactlinkApp.leftMiddleRegion.show(topicSidebarView)

      topicSidebarView.setActiveChannel(currentChannel)
    else
      username = user.get('username')
      window.Channels.setUsernameAndRefreshIfNeeded(username)

      channelCollectionView = new ChannelsView
        collection: channels
        model: user
      FactlinkApp.leftMiddleRegion.show(channelCollectionView)

      channelCollectionView.setActiveChannel(currentChannel)
