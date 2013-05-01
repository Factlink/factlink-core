class window.ConversationsController extends Backbone.Factlink.CachingController

  routes: ['showConversations', 'showMessages']

  onShow: ->
    FactlinkApp.closeAllContentRegions()
    @main ?= new TabbedMainRegionLayout()
    FactlinkApp.mainRegion.show(@main)

  showConversations: ->
    @conversations ?= new Conversations()
    @main.showTitle 'Messages'
    @main.contentRegion.show(
      new ConversationsView collection: @conversations, loading: true
    )
    FactlinkApp.Sidebar.showForTopicsAndActivateCorrectItem(null, currentUser)
    @conversations.fetch()

  showMessages: (conversation_id, message_id=null)->
    @main = new TabbedMainRegionLayout()
    FactlinkApp.mainRegion.show(@main)

    @conversation = new Conversation(id: conversation_id)
    FactlinkApp.Sidebar.showForTopicsAndActivateCorrectItem(null, currentUser)
    @conversation.fetch
      success: (model, response) =>
        @renderMessages(model)

        title_view = new ConversationTitleView( model: model )
        title_view.on 'showConversations', =>
          @showConversations()
          Backbone.history.navigate '/m', false

        @main.titleRegion.show(title_view)
        model.messages().get(message_id)?.trigger('scroll') if message_id?

  renderMessages: (conversation) ->
    conversationView = new MessagesView
      model: conversation
      collection: conversation.messages()

    @main.contentRegion.show conversationView
