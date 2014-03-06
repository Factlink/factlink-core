class window.FeedsController extends Backbone.Marionette.Controller
  showFeed: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactFeedSelection()

    mp_track 'Viewed feed'
