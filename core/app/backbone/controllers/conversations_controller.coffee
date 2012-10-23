app = FactlinkApp

class window.ConversationsController
  showConversations: ->
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @main.showTitle "Conversations"

    @conversation = new Conversations()
    @conversation.fetch
      success: (collection, response) => @renderConversations(collection)

  renderConversations: (conversations) ->
    @main.contentRegion.show(
      new ConversationsView
        collection: conversations
    )

  showMessages: (conversation_id)->
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @conversation = new Conversation(id: conversation_id)
    @conversation.fetch
      success: (model, response) =>
        @renderMessages(model)

        title_view = new ConversationTitleView( model: model )
        @main.titleRegion.show( title_view )

  renderMessages: (conversation) ->
    messages = new Messages(conversation.get('messages'))
    @main.contentRegion.show(
      new MessagesView
        model: conversation
        collection: messages
    )
