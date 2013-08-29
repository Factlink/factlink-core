class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username/channels/:channel_id':                 'showChannelFacts'
    ':username/channels/:channel_id/activities':      'showChannelActivities'
    't/:slug_title':                                  'showTopicFacts'
