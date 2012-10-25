class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  initialize: ->
    @message = new Message

  submit: ->
    @message.set 'conversation_id', @model.id
    @message.set 'sender_id', currentUser.id
    @message.set 'content', @$('.text').val()

    @showAlert null
    @disableSubmit()
    @message.save [],
      success: =>
        @message = new Message
        @showAlert 'success'
        @enableSubmit()
        @clearForm()

      error: =>
        @showAlert 'error'
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')

  showAlert: (type) ->
    @$('.alert').addClass 'hide'
    @$('.alert-' + type).removeClass 'hide' if type?
