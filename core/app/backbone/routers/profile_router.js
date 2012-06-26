ProfileRouter = Backbone.Marionette.AppRouter.extend({
  appRoutes: {
    ':username': 'showProfile',
  }
});
