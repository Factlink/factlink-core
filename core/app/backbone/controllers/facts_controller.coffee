class window.FactsController extends Backbone.Marionette.Controller
  constructor: (@options) ->

  showStream: ->
    FactlinkApp.mainRegion.show new FeedActivitiesView
      collection: new FeedActivities

    mp_track 'Viewed feed'
