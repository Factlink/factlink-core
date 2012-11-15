class window.ProfileRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username': 'onShowProfile'
    ':username/notification-settings': 'onShowNotificationSettings'
