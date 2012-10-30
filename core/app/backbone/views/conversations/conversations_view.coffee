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

  onShow: ->
    @$('.text').trunk8 lines: 2

  wholeElementClick: (e) ->
    url = @model.url()
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate url, true

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
