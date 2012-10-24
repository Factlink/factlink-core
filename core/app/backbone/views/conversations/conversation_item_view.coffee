nlToBr = (str)-> str.replace(/\n/g, '<br />');

class window.ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/item'
  events:
    'click' : 'wholeElementClick'

  initialize: ->
    @otherRecipients = @model.otherRecipients()

  templateHelpers: =>
    first_recipient: @otherRecipients[0].toJSON()
    recipients_comma: @otherRecipients.map((user) -> user.get('name')).join(', ')
    reply: @model.get('last_message').sender.id == currentUser.id
    html_content: nlToBr(htmlEscape(@model.get('last_message').content))

  onShow: ->
    @$('.text').trunk8 lines: 2

  wholeElementClick: (e) ->
    url = @model.url()
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate url, true
