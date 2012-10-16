class window.SendMessageView extends Backbone.Marionette.ItemView
  events:
    "click .submit": 'submit'

  template: 'messages/send'

  initialize: ->
    @model = new Conversation

  submit: ->
    @model.set 'recipients', [@$('.recipient').val(), currentUser.get('username')]
    @model.set 'sender', currentUser.get('username')
    @model.set 'content', @$('.content').val()
    console.info "MESSAGE", @model.toJSON()
    @model.save()
