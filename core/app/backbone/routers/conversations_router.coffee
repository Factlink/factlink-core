class window.ConversationsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'm'                 : 'showConversations'
    'm/:conversation_id': 'showMessages'