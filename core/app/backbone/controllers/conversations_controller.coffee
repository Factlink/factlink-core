#= require './channels_controller'
app = FactlinkApp

class window.ConversationsController extends Backbone.Factlink.BaseController

  routes: ['showConversations', 'showMessages']

  onShow: ->
    app.closeAllContentRegions()
    @main ?= new TabbedMainRegionLayout()
    app.mainRegion.show(@main)

  showConversations: ->
    @conversations ?= new Conversations()
    @main.showTitle 'Messages'
    @main.contentRegion.show(
      new ConversationsView collection: @conversations, loading: true
    )
    FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem(window.Channels, null, currentUser)
    @conversations.fetch()

  showMessages: (conversation_id, message_id=null)->
    @main = new TabbedMainRegionLayout()
    app.mainRegion.show(@main)

    @conversation = new Conversation(id: conversation_id)
    FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem(window.Channels, null, currentUser)
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
