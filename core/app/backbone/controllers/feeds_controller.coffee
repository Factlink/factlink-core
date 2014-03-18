class window.FeedsController extends Backbone.Router
  routes:
    'feed': 'showFeed'

  showFeed: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactFeedSelection()

    mp_track 'Viewed feed'
