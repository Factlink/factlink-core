class window.TourController

  chooseChannels:  ->
    stream = window.Channels.models[0]

    channelCollectionView = new ChannelsView(collection: window.Channels)
    FactlinkApp.leftBottomRegion.show(channelCollectionView)
    activities = new ChannelActivities([],{ channel: stream })
    FactlinkApp.mainRegion.show(
      new ChannelActivitiesView
        model: stream
        collection: activities)

    @suggestedUserChannels = new TopChannelList()
    @suggestedUserChannels.fetch()



    FactlinkApp.leftMiddleRegion.show(
      new UserChannelSuggestionsView(
        addToCollection: window.Channels
        addToActivities: activities
        collection: @suggestedUserChannels))