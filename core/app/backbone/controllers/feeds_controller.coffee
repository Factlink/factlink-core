class window.FeedsController extends Backbone.Marionette.Controller
  showFeed: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactFeedActivities
        model: new FeedActivities

    mp_track 'Viewed feed'
