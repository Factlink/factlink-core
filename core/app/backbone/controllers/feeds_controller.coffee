class window.FeedsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'feed': 'showFeed'

window.FeedsController =
  showFeed: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactFeedSelection()

    mp_track 'Viewed feed'
