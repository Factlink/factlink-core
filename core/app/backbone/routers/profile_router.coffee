class window.ProfileRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    ':username': 'onShowProfile'
    ':username/notification-settings': 'onShowNotificationSettings'

    ':slug/f/:fact_id': 'onShowFact'
