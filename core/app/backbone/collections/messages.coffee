class window.Messages extends Backbone.Collection
  model: Message

  initialize: (models, options) -> @conversationId = options.conversation.id

  # Warning: does not work for fetch
  url: -> "/m/#{@conversationId}/messages"

  createNew: (content, sender, options)->
    message = new Message
      content: content
      sender: sender
    @add message
    message.save [],
      success: (args...) => options.success?(args...)
      error: (args...) =>
        @remove message
        options.error?(args...)
