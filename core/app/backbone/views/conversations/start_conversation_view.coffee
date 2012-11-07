class window.StartConversationView extends Backbone.Marionette.Layout
  className: "start-conversation-form"
  events:
    "click .submit": 'submit'

  regions:
    'recipients_container': 'div.recipients'

  template: 'conversations/start_conversation'

  initialize: ->
    @recipients = new Users
    @auto_complete_view = new AutoCompleteUsersView(collection: @recipients)

  onRender: ->
    @recipients_container.show @auto_complete_view

  submit: ->
    # Check for the length of `@recipients`, not `recipients`, to allow sending message to oneself
    if @recipients.length <= 0
      @showAlert 'error'
      return

    recipients = _.union(@recipients.pluck('username'), [currentUser.get('username')])

    conversation = new Conversation(
      recipients: recipients
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
