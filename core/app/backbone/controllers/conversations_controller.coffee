app = FactlinkApp

class window.ConversationsController extends Backbone.Factlink.BaseController

  routes: ['showConversations', 'showMessages']

  onShow: ->
    app.closeAllContentRegions()
    @main ?= new TabbedMainRegionLayout()
    app.mainRegion.show(@main)

  showConversations: ->
    @conversations ?= new Conversations()
    @main.showTitle "Conversations"
    @main.contentRegion.show(
      new ConversationsView collection: @conversations, loading: true
    )
    @showChannelListing()
    @conversations.fetch()

  showMessages: (conversation_id, message_id=null)->
    @main = new TabbedMainRegionLayout()
    app.mainRegion.show(@main)

    @conversation = new Conversation(id: conversation_id)
    @showChannelListing()
    @conversation.fetch
      success: (model, response) =>
        @renderMessages(model)

        title_view = new ConversationTitleView( model: model )
        title_view.on 'showConversations', =>
          @showConversations()
          Backbone.history.navigate '/c', false

        @main.titleRegion.show(title_view)
        model.messages().get(message_id)?.trigger('scroll') if message_id?

  renderMessages: (conversation) ->
    conversationView = new MessagesView
      model: conversation
      collection: conversation.messages()

    @main.contentRegion.show conversationView

  showChannelListing: ->
    username = currentUser.get('username')
    changed = window.Channels.setUsernameAndRefresh(username)
    channelCollectionView = new ChannelsView(collection: window.Channels)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActive('conversations')
