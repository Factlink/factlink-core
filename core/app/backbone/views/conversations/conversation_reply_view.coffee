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

    @hideError
    @disableSubmit()
    @message.save [],
      success: =>
        @message = new Message
        @enableSubmit()
        @clearForm()
        @trigger('submit')

      error: =>
        @showError
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send message')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')
  showError:     -> @$('.alert-error').removeClass 'hide'
  hideError:     -> @$('.alert-error').removeClass 'show'
