class window.TourController

  chooseChannels:  ->
    stream = window.Channels.models[0]

    visibleAddedChannels = collectionDifference(ChannelList, 'is_normal', window.Channels,
     [{is_normal: false}])

    channelCollectionView = new EditableChannelsView(collection: visibleAddedChannels)
    activities = new ChannelActivities([],{ channel: stream })
    FactlinkApp.mainRegion.show(
      new ChannelActivitiesView
        model: stream
        collection: activities)

    @suggestedUserChannels = new TopChannelList()
    @suggestedUserChannels.fetch()

    FactlinkApp.leftTopXFadeRegion.crossFade(tourstep = new AddChannelsTourStep1())

    tourstep.on 'next', =>
      FactlinkApp.leftTopXFadeRegion.crossFade(new AddChannelsTourStep2())
      FactlinkApp.leftBottomRegion.show(channelCollectionView)
      FactlinkApp.leftMiddleRegion.show(
        suggestionview = new UserChannelSuggestionsView(
          addToCollection: window.Channels
          addToActivities: activities
          collection: @suggestedUserChannels))
      suggestionview.on 'added', ->
        FactlinkApp.leftTopXFadeRegion.crossFade(tourstep = new AddChannelsTourStep3())
        tourstep.on 'next', -> window.location = '/'