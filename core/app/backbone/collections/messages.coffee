class window.Messages extends Backbone.Collection
  model: Message

  initialize: (models, options) -> @conversationId = options.conversation.id

  url: -> "/c/#{@conversationId}/messages"

  createNew: (content, sender, options)->
    message = new Message
      content: content
      sender: sender
    @add message
    message.save [],
      success: => options.success?()
      error: =>
        @remove message
        options.error?()
