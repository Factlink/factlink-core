class ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/item'
  events:
    'click' : 'wholeElementClick'

  initialize: -> @otherRecipients = @model.otherRecipients(currentUser)

  templateHelpers: =>
    last_message = @model.get('last_message')

    first_recipient: @otherRecipients[0].toJSON()
    recipients_comma: @otherRecipients.map((user) -> user.get('name')).join(', ')
    reply: last_message and last_message.sender.id == currentUser.id

  wholeElementClick: (e) -> @defaultClickHandler e, @model.url()

class ConversationEmptyView extends Backbone.Marionette.ItemView
  template: 'conversations/empty'

class ConversationEmptyLoadingView extends Backbone.Factlink.EmptyLoadingView
  emptyView: ConversationEmptyView
  className: 'empty'

class window.ConversationsView extends Backbone.Marionette.CollectionView
  itemView: ConversationItemView
  emptyView: ConversationEmptyLoadingView
  itemViewOptions: => collection: @collection
  tagName: 'ul'
  className: 'conversations'
