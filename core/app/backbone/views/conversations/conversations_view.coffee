class window.ConversationListView extends Backbone.Marionette.CollectionView
  itemView: ConversationItemView
  className: 'conversations'
  tagName: 'ul'

class window.ConversationsView extends Backbone.Marionette.Layout
  className: 'conversation'
  template: 'conversations/index'

  regions:
    conversationsRegion: ".message-list"

  onShow: ->
    @conversationsRegion.show new ConversationListView(collection: @collection)
