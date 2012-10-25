class ConversationEmptyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  className: 'empty'
  template: 'conversations/empty'
  templateHelpers: => loading: @options.loading

class window.ConversationsView extends Backbone.Marionette.CollectionView
  itemView: ConversationItemView
  emptyView: ConversationEmptyView
  itemViewOptions: => loading: @options.loading
  tagName: 'ul'
  className: 'conversations'

  initialize: ->
    @collection.on 'reset', => @options.loading = false
