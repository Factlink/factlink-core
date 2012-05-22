ProfileRouter = Backbone.Marionette.AppRouter.extend({
  appRoutes: {
    ':username': 'showProfile',
  }
});
new ProfileRouter({controller: ProfileController});
