ChannelsRouter = Backbone.Marionette.AppRouter.extend({
  appRoutes: {
    ':username/channels/:channel_id': 'getChannelFacts',
    ':username/channels/:channel_id/activities': 'getChannelActivities'
  }
});
new ChannelsRouter({controller: ChannelsController});
