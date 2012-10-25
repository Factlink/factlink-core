class ConversationEmptyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  className: 'empty'
  template: 'conversations/empty'

class window.ConversationListView extends Backbone.Marionette.CollectionView
  itemView: ConversationItemView
  emptyView: ConversationEmptyView
  tagName: 'ul'
  className: 'conversations'

class window.ConversationsView extends Backbone.Marionette.Layout
  template: 'conversations/index'
