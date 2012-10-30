class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  submit: ->
    @message = new Message
      content: @$('.text').val()
      sender: currentUser
    @model.messages().add @message

    @displayError false
    @disableSubmit()
    @message.save [],
      success: =>
        @clearForm()
        @enableSubmit()

      error: =>
        @displayError true
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send message')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')
  displayError: (value) -> @$('.alert-error').toggle(value)
