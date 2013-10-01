class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  ui:
    submit: '.submit'

  submit: ->
    return if @submitting

    @disableSubmit()

    @model.messages().createNew @$('.text').val(), currentUser,
      success: =>
        @clearForm()
        @enableSubmit()

      error: (model, response) =>
        @_showError response.responseText
        @enableSubmit()

  _showError: (type) ->
    switch type
      when 'Content cannot be empty'
        FactlinkApp.NotificationCenter.error 'Please enter a message.'
      else
        FactlinkApp.NotificationCenter.error 'Your message could not be sent, please try again.'

  enableSubmit:  ->
    @submitting = false
    @ui.submit.prop('disabled',false).val('Send message')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).val('Sending...')

  clearForm:     -> @$('.recipients, .message-textarea').val('')
