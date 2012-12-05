class window.StartConversationView extends Backbone.Marionette.Layout
  className: "start-conversation-form"
  events:
    "click .submit": 'submit'

  regions:
    'recipients_container': 'div.recipients'

  template: 'conversations/start_conversation'

  initialize: ->
    @alertErrorInit ['user_not_found', 'message_empty']

    @recipients = new Users
    @auto_complete_view = new AutoCompleteUsersView(collection: @recipients)

  onRender: ->
    @recipients_container.show @auto_complete_view
    @recipients.on 'add', @newRecipient

  newRecipient: =>
    @$('.message-textarea').focus() if @recipients.length == 1

  submit: (e) ->
    e.preventDefault()

    # Check for the length of `@recipients`, not `recipients`, to allow sending message to oneself
    if @recipients.length <= 0
      @alertShow 'error'
      return

    recipients = _.union(@recipients.pluck('username'), [currentUser.get('username')])

    conversation = new Conversation(
      recipients: recipients
      sender: currentUser.get('username')
      content: @$('.text').val()
      fact_id: @model.id
    )

    @alertHide()
    @disableSubmit()
    conversation.save [],
      success: =>
        @alertShow 'success'
        @enableSubmit()
        @clearForm()

      error: (model, response) =>
        @alertError response.responseText
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')

  clearForm: ->
    @recipients.reset []
    @$('.message-textarea').val('')

_.extend(StartConversationView.prototype, Backbone.Factlink.AlertMixin)
