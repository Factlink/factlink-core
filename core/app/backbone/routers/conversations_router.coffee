class window.ConversationsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'm'                                      : 'showConversations'
    'm/:conversation_id'                     : 'showMessages'
    'm/:conversation_id/messages/:message_id': 'showMessages'
