class window.ConversationTitleView extends Backbone.Marionette.ItemView
  tagName: "header"
  id: "conversation"
  template: "conversations/detailed_header"

  triggers:
    'click #back-to-conversations-button' : 'showConversations'

  templateHelpers: =>
    recipients_comma: @model.otherRecipients().map((user) -> user.get('name')).join(', ')
