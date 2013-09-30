class window.ProfileRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username': 'showProfile'
    ':username/notification-settings': 'showNotificationSettings'
