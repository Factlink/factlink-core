class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  submit: ->
    @message = new Message
    @message.set('content', @$('.text').val())
    @message.set('sender', currentUser)
    @model.messages().push(@message)

    @error('hide')
    @disableSubmit()
    @message.save [],
      success: =>
        @clearForm()
        @enableSubmit()

      error: =>
        @error('show')
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send message')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')
  error: (value) -> @$('.alert-error').addClass(value)
