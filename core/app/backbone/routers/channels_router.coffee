class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username/channels/:channel_id':                 'onGetChannelFacts'
    ':username/channels/:channel_id/facts/:fact_id':  'onGetChannelFact'

    ':username/channels/:channel_id/activities':      'onGetChannelActivities'
    ':username/channels/:channel_id/activities/facts/:fact_id': 'onGetChannelFactForActivity'

