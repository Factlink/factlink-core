class window.ConversationsRouter extends Backbone.Marionette.AppRouter
  appRoutes:
    'm'                                      : 'onShowConversations'
    'm/:conversation_id'                     : 'onShowMessages'
    'm/:conversation_id/messages/:message_id': 'onShowMessages'
