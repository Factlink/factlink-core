class window.StartConversationView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AlertMixin

  className: "start-conversation-form"
  events:
    "click .js-submit": 'submit'
    "focus .js-message-textarea": 'handleTextAreaFocus'
    "keyup .js-message-textarea": 'handleTextAreaFocus'

  regions:
    'recipients_container': '.js-region-recipients'

  ui:
    messageTextarea: '.js-message-textarea'
    submit:          '.js-submit'

  template: 'conversations/start_conversation'

  initialize: ->
    @alertErrorInit ['user_not_found', 'message_empty']

    @options.defaultMessage ||= "Check out this Factlink!"

    @recipients = new Users
    @auto_complete_view = new AutoCompleteUsersView(collection: @recipients)

  onRender: ->
    @recipients_container.show @auto_complete_view
    @recipients.on 'add', @newRecipient

    @ui.messageTextarea.val @options.defaultMessage

  handleTextAreaKeyUp: ->
    keycode = e.keyCode || e.which || e.charCode
    return if keycode isnt 9

    @focusUnchangedTextArea()

  handleTextAreaFocus: (e)->
    @focusUnchangedTextArea()

    # mouseup shouldn't trigger stuff, otherwise
    # text will be deselected again
    @ui.messageTextarea.on "mouseup", =>
      @ui.messageTextarea.off "mouseup"
      return false;

  focusUnchangedTextArea: ->
    if @ui.messageTextarea.val() is @options.defaultMessage
      @ui.messageTextarea.select()

  newRecipient: =>
    @ui.messageTextarea.focus() if @recipients.length == 1

  submit: (e) ->
    e.preventDefault()

    return if @submitting

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

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).val('Send')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).val('Sending...')

  clearForm: ->
    @auto_complete_view.clearSearch()
    @recipients.reset []
