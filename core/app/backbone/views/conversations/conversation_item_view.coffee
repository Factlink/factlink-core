class window.ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/item'
  events:
    'click' : 'wholeElementClick'

  initialize: =>
    @otherRecipients = @model.otherRecipients()

  templateHelpers: =>
    first_recipient: @otherRecipients[0].toJSON()
    recipients_comma: @otherRecipients.map((user) -> user.get('name')).join(', ')
    reply: @model.get('last_message').sender.id != currentUser.id

  wholeElementClick: (e) ->
    url = @model.url()
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate url, true
