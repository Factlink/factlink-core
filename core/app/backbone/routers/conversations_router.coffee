class window.ConversationsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'c'                 : 'showConversations'
    'c/:conversation_id': 'showMessages'
