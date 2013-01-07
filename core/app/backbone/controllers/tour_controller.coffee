class window.TourController extends Backbone.Factlink.BaseController

  routes: ['chooseChannels']

  chooseChannels:  ->
    stream = currentUser.stream()

    visibleAddedChannels = collectionDifference(new ChannelList, 'is_normal', window.Channels,
     [{is_normal: false}])

    channelCollectionView = new EditableChannelsView(collection: visibleAddedChannels)
    window.Channels.fetch()

    activities = new ChannelActivities([],{ channel: stream })

    activities_view = new ChannelActivitiesView
      model: stream
      collection: activities
      hideEmptyView: true

    FactlinkApp.mainRegion.show activities_view

    activities_view.activityList.currentView.addAtBottom new BananasView(collection: activities)

    @suggestedUserChannels = new TopChannelList()
    @suggestedUserChannels.fetch()

    FactlinkApp.leftTopCrossFadeRegion.crossFade(tourstep = new AddChannelsTourStep1())

    tourstep.on 'next', =>
      done = false

      FactlinkApp.leftTopCrossFadeRegion.crossFade(new AddChannelsTourStep2())
      FactlinkApp.leftBottomRegion.show(channelCollectionView)
      FactlinkApp.leftMiddleRegion.show(
        suggestionview = new UserChannelSuggestionsView(
          addToCollection: window.Channels
          addToActivities: activities
          collection: @suggestedUserChannels))
      suggestionview.on 'added', =>
        unless done
          done = true
          FactlinkApp.leftTopCrossFadeRegion.crossFade(tourstep = new AddChannelsTourStep3())
          tourstep.on 'next', -> window.location = '/'
