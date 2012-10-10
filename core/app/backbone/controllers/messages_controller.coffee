app = FactlinkApp

class window.MessagesController
  showMessage: (message_id)->
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @main.showTitle "Message #{message_id}"

    @conversation = new Conversation(id: message_id)
    @conversation.fetch
      success: (model, response)=> @showConversation(model)

  showConversation: (conversation)->
    messages = new Messages(conversation.get('messages'))
    @main.contentRegion.show(
      new MessageView
        model: conversation
        collection: messages
    )
