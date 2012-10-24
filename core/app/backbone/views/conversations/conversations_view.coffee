class window.ConversationListView extends Backbone.Marionette.CollectionView
  itemView: ConversationItemView
  tagName: 'ul'

class window.ConversationsView extends Backbone.Marionette.Layout
  className: 'conversations'
  template: 'conversations/index'

  regions:
    conversationsRegion: ".message-list"

  onRender: ->
    @conversationsRegion.show new ConversationListView(collection: @collection)
