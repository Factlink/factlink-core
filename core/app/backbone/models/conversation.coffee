class window.Conversation extends Backbone.Model
  urlRoot: '/m'
  recipients: => new Users(@get('recipients'))
  otherRecipients: =>
    recipients = @recipients()
    result = recipients.filter((user) -> user.id != currentUser.id)
    if result.length <= 0 then result = [recipients.first()]
    result
