class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username/channels/:channel_id':                 'showChannelFacts'
    ':username/channels/:channel_id/facts/:fact_id':  'showChannelFact'

    ':username/channels/:channel_id/activities':      'showChannelActivities'
    ':username/channels/:channel_id/activities/facts/:fact_id': 'showChannelFactForActivity'

    't/:slug_title':                                  'showTopicFacts'
    't/:slug_title/facts/:fact_id':                   'showTopicFact'

