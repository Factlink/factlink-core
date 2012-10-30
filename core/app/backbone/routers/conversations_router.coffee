class window.ConversationsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'c'                                      : 'navigateConversations'
    'c/:conversation_id'                     : 'navigateMessages'
    'c/:conversation_id/messages/:message_id': 'navigateMessages'
