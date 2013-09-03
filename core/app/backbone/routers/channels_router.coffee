class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username/channels/:channel_id':                          'showChannelFacts'
    ':username_unused/channels/:channel_id_unused/activities': 'showStream'
    't/:slug_title':                                           'showTopicFacts'

    ':slug/f/:fact_id': 'showFact'

  initialize: ->
    FactlinkApp.addInitializer =>
      FactlinkApp.showFactRegex = @_routeToRegExp ':slug/f/:fact_id'
