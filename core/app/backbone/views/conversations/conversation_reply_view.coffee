class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  submit: ->
    @showAlert null
    @disableSubmit()

    @model.messages().createNew @$('.text').val(), currentUser,
      success: =>
        @clearForm()
        @enableSubmit()

      error: (model, response) =>
        if response.responseText in ['message_empty']
          @showAlert response.responseText
        else
          @showAlert 'error'
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send message')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')
  displayError: (value) -> @$('.alert-error').toggle(value)

  showAlert: (type) ->
    @$('.alert').addClass 'hide'
    @$('.alert-type-' + type).removeClass 'hide' if type?
