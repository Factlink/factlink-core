class window.ChannelsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username/channels/:channel_id': 'getChannelFacts'
    ':username/channels/:channel_id/activities': 'getChannelActivities'