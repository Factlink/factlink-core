class window.FeedsController extends Backbone.Marionette.Controller
  showFeed: ->
    FactlinkApp.mainRegion.show new FeedActivitiesView
      collection: new FeedActivities

    mp_track 'Viewed feed'
