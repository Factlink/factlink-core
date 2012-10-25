app = FactlinkApp

class window.ConversationsController
  startAction: ->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    return if @alreadyLoaded
    @conversations = new Conversations()
    @alreadyLoaded = true

  showConversations: (with_startup=true)->
    @startAction() if with_startup

    @main.showTitle "Conversations"
    @main.contentRegion.show(
      new ConversationListView
        collection: @conversations
    )

    @conversations.fetch()

  showMessages: (conversation_id, with_startup=true)->
    @startAction() if with_startup

    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @conversation = new Conversation(id: conversation_id)
    @conversation.fetch
      success: (model, response) =>
        @renderMessages(model)

        title_view = new ConversationTitleView( model: model )
        title_view.on 'showConversations', =>
          @showConversations false
          Backbone.history.navigate '/m', false

        @main.titleRegion.show( title_view )

  renderMessages: (conversation) ->
    messages = new Messages(conversation.get('messages'))
    conversationView =  new MessagesView
      model: conversation
      collection: messages

    @main.contentRegion.show conversationView
