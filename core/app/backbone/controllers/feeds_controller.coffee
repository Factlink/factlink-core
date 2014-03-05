class window.FeedsController extends Backbone.Marionette.Controller
  showFeed: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactFeedActivitiesAutoLoading
        model: new FeedActivities

    mp_track 'Viewed feed'
