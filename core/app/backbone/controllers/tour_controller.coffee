class window.TourController

  chooseChannels:  ->
    stream = window.Channels.models[0]

    visibleAddedChannels = collectionDifference(ChannelList, 'is_normal', window.Channels,
     [{is_normal: false}])

    channelCollectionView = new EditableChannelsView(collection: visibleAddedChannels)
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