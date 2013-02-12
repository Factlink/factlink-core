class window.Conversation extends Backbone.Model
  urlRoot: '/m'

  recipients: ->
    @_recipients ?= new Users(@get('recipients'))

  messages: ->
    @_messages ?= new Messages(@get('messages'), conversation: this)

  otherRecipients: (user) ->
    result = @recipients().filter((u) -> u.id != user.id)
    if result.length <= 0 then result = [user]
    result
