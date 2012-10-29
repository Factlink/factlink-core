class window.Messages extends Backbone.Collection
  model: Message

  initialize: (models, options) -> @conversationId = options.conversation.id

  url: -> "/c/#{@conversationId}/messages"
