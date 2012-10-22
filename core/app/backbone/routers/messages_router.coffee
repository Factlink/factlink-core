class window.MessagesRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'm/:message_id': 'showMessage'