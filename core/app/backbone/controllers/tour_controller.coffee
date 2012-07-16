class window.TourController

  chooseChannels:  ->
    channelCollectionView = new ChannelsView(collection: window.Channels)
    FactlinkApp.leftMiddleRegion.show(channelCollectionView)
    FactlinkApp.mainRegion.show(new ChannelActivitiesView(model: window.Channels.models[0]))