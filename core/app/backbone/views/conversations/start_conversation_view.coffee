class window.StartConversationView extends Backbone.Marionette.Layout
  className: "start-conversation-form"
  events:
    "click .js-submit": 'submit'

  regions:
    'recipients_container': '.js-region-recipients'

  ui:
    messageTextarea: '.js-message-textarea'
    submitButton:    '.js-submit'

  template: 'conversations/start_conversation'

  initialize: ->
    @alertErrorInit ['user_not_found', 'message_empty']

    @recipients = new Users
    @auto_complete_view = new AutoCompleteUsersView(collection: @recipients)

  onRender: ->
    @recipients_container.show @auto_complete_view
    @recipients.on 'add', @newRecipient

  newRecipient: =>
    @ui.messageTextarea.focus() if @recipients.length == 1

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
      content: @ui.messageTextarea.val()
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

  enableSubmit:  -> @ui.submitButton.prop('disabled',false).val('Send')
  disableSubmit: -> @ui.submitButton.prop('disabled',true ).val('Sending')

  clearForm: ->
    @auto_complete_view.clearSearch()
    @recipients.reset []
    @ui.messageTextarea.val ''

_.extend(StartConversationView.prototype, Backbone.Factlink.AlertMixin)
