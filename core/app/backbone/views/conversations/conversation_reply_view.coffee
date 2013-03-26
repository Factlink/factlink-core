class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  ui:
    submit: '.submit'

  initialize: ->
    @alertErrorInit ['message_empty']

  submit: ->
    return if @submitting
    
    @alertHide()
    @disableSubmit()

    @model.messages().createNew @$('.text').val(), currentUser,
      success: =>
        @clearForm()
        @enableSubmit()

      error: (model, response) =>
        @alertError response.responseText
        @enableSubmit()

  enableSubmit:  -> 
    @submitting = false
    @ui.submit.prop('disabled',false).val('Send message')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).val('Sending...')

  clearForm:     -> @$('.recipients, .message-textarea').val('')

_.extend(ConversationReplyView.prototype, Backbone.Factlink.AlertMixin)
