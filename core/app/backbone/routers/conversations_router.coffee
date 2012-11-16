class window.ConversationsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'c'                                      : 'onShowConversations'
    'c/:conversation_id'                     : 'onShowMessages'
    'c/:conversation_id/messages/:message_id': 'onShowMessages'
