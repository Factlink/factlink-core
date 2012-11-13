class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username/channels/:channel_id':                 'getChannelFacts'
    ':username/channels/:channel_id/facts/:fact_id':  'getChannelFact'

    ':username/channels/:channel_id/activities':      'getChannelActivities'
    ':username/channels/:channel_id/activities/facts/:fact_id': 'getChannelFactForActivity'

