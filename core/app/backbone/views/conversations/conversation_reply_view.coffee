class window.ConversationReplyView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'conversations/reply'
  events:
    "click .submit": 'submit'

  initialize: ->
    @alertErrorInit ['message_empty']

  submit: ->
    @alertHide()
    @disableSubmit()

    @model.messages().createNew @$('.text').val(), currentUser,
      success: =>
        @clearForm()
        @enableSubmit()

      error: (model, response) =>
        @alertError response.responseText
        @enableSubmit()

  enableSubmit:  -> @$('.submit').prop('disabled',false).val('Send message')
  disableSubmit: -> @$('.submit').prop('disabled',true ).val('Sending')
  clearForm:     -> @$('.recipients, .message-textarea').val('')

_.extend(ConversationReplyView.prototype, Backbone.Factlink.AlertMixin)
