class window.ConversationListView extends Backbone.Marionette.CollectionView
  itemView: ConversationItemView
  tagName: 'ul'
  className: 'conversations'

class window.ConversationsView extends Backbone.Marionette.Layout
  template: 'conversations/index'
