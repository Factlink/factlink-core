app = FactlinkApp

class window.ConversationsController
  startAction: ->
    app.closeAllContentRegions()
    @main ?= new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

  navigateConversations: ->
    @startAction()
    @showConversations()

  navigateMessages: (args...) ->
    @startAction()
    @showMessages(args...)

  showConversations: ->
    @conversations ?= new Conversations()
    @main.showTitle "Conversations"
    @main.contentRegion.show(
      new ConversationsView collection: @conversations, loading: true
    )

    @conversations.fetch()

  showMessages: (conversation_id, message_id=null)->
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @conversation = new Conversation(id: conversation_id)
    @conversation.fetch
      success: (model, response) =>
        @renderMessages(model)

        title_view = new ConversationTitleView( model: model )
        title_view.on 'showConversations', =>
          @showConversations()
          Backbone.history.navigate '/c', false

        @main.titleRegion.show(title_view)
        model.messages().get(message_id)?.trigger('highlight') if message_id?
        console.log( model.messages().get(message_id) ) if message_id?

  renderMessages: (conversation) ->
    conversationView = new MessagesView
      model: conversation
      collection: conversation.messages()

    @main.contentRegion.show conversationView
