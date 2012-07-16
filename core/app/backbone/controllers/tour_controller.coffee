class window.TourController

  chooseChannels:  ->
    channelCollectionView = new ChannelsView(collection: window.Channels)
    FactlinkApp.leftBottomRegion.show(channelCollectionView)
    FactlinkApp.mainRegion.show(new ChannelActivitiesView(model: window.Channels.models[0]))

    @suggestedUserChannels = new TopChannelList()
    @suggestedUserChannels.fetch()

    FactlinkApp.leftMiddleRegion.show(
      new UserChannelSuggestionsView(
        addToCollection: window.Channels
        collection: @suggestedUserChannels))