class window.StartConversationView extends Backbone.Marionette.ItemView
  className: "start-conversation-form"
  events:
    "click .submit": 'submit'

  template: 'conversations/start_conversation'

  submit: ->
    conversation = new Conversation(
      recipients: [@$('.recipients').val(), currentUser.get('username')]
      sender: currentUser.get('username')
      content: @$('.text').val()
      fact_id: @model.id
    )

    @showAlert null
    @disableSubmit()
    conversation.save [],
      success: =>
        @showAlert 'success'
        @enableSubmit()
        @clearForm()

      error: (model, response) =>
        if response.responseText in ['user_not_found']
          @showAlert response.responseText
        else
          @showAlert 'error'
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')

  showAlert: (type) ->
    @$('.alert').addClass 'hide'
    @$('.alert-type-' + type).removeClass 'hide' if type?
